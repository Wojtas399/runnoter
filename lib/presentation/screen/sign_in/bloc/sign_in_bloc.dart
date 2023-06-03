import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/additional_model/auth_exception.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../../domain/service/connectivity_service.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc
    extends BlocWithStatus<SignInEvent, SignInState, SignInInfo, SignInError> {
  final AuthService _authService;
  final ConnectivityService _connectivityService;

  SignInBloc({
    required AuthService authService,
    required ConnectivityService connectivityService,
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
    String password = '',
  })  : _authService = authService,
        _connectivityService = connectivityService,
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
    if (await _connectivityService.hasDeviceInternetConnection() == false) {
      emitNoInternetConnectionStatus(emit);
      return;
    }
    try {
      await _tryToSignIn();
      emitCompleteStatus(emit, SignInInfo.signedIn);
    } on AuthException catch (authException) {
      final SignInError? error = _mapAuthExceptionToBlocError(authException);
      if (error != null) {
        emitErrorStatus(emit, error);
      } else {
        emitUnknownErrorStatus(emit);
        rethrow;
      }
    } catch (_) {
      emitUnknownErrorStatus(emit);
      rethrow;
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

  SignInError? _mapAuthExceptionToBlocError(AuthException exception) {
    if (exception == AuthException.invalidEmail) {
      return SignInError.invalidEmail;
    } else if (exception == AuthException.userNotFound) {
      return SignInError.userNotFound;
    } else if (exception == AuthException.wrongPassword) {
      return SignInError.wrongPassword;
    }
    return null;
  }
}
