import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/custom_exception.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc
    extends BlocWithStatus<SignInEvent, SignInState, SignInInfo, SignInError> {
  final AuthService _authService;

  SignInBloc({
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
    String password = '',
  })  : _authService = getIt<AuthService>(),
        super(
          SignInState(
            status: status,
            email: email,
            password: password,
          ),
        ) {
    on<SignInEventInitialize>(_initialize);
    on<SignInEventEmailChanged>(_emailChanged);
    on<SignInEventPasswordChanged>(_passwordChanged);
    on<SignInEventSubmit>(_submit);
  }

  Future<void> _initialize(
    SignInEventInitialize event,
    Emitter<SignInState> emit,
  ) async {
    emitLoadingStatus(emit);
    SignInInfo? info;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId != null) {
      info = SignInInfo.signedIn;
    }
    emitCompleteStatus(emit, info);
  }

  void _emailChanged(
    SignInEventEmailChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  void _passwordChanged(
    SignInEventPasswordChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
    ));
  }

  Future<void> _submit(
    SignInEventSubmit event,
    Emitter<SignInState> emit,
  ) async {
    if (_isFormNotCompleted()) {
      return;
    }
    emitLoadingStatus(emit);
    try {
      await _tryToSignIn();
      emitCompleteStatus(emit, SignInInfo.signedIn);
    } on AuthException catch (authException) {
      final SignInError? error = _mapAuthExceptionCodeToBlocError(
        authException.code,
      );
      if (error != null) {
        emitErrorStatus(emit, error);
      } else {
        emitUnknownErrorStatus(emit);
        rethrow;
      }
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNetworkRequestFailed(emit);
      }
    } on UnknownException catch (unknownException) {
      emitUnknownErrorStatus(emit);
      throw unknownException.message;
    }
  }

  bool _isFormNotCompleted() {
    return state.email.isEmpty || state.password.isEmpty;
  }

  Future<void> _tryToSignIn() async {
    await _authService.signIn(
      email: state.email,
      password: state.password,
    );
  }

  SignInError? _mapAuthExceptionCodeToBlocError(
    AuthExceptionCode authExceptionCode,
  ) {
    if (authExceptionCode == AuthExceptionCode.invalidEmail) {
      return SignInError.invalidEmail;
    } else if (authExceptionCode == AuthExceptionCode.userNotFound) {
      return SignInError.userNotFound;
    } else if (authExceptionCode == AuthExceptionCode.wrongPassword) {
      return SignInError.wrongPassword;
    }
    return null;
  }
}
