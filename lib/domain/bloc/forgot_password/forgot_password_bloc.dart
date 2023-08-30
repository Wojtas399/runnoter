import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/custom_exception.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends BlocWithStatus<ForgotPasswordEvent,
    ForgotPasswordState, ForgotPasswordBlocInfo, ForgotPasswordBlocError> {
  final AuthService _authService;

  ForgotPasswordBloc({
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
  })  : _authService = getIt<AuthService>(),
        super(
          ForgotPasswordState(
            status: status,
            email: email,
          ),
        ) {
    on<ForgotPasswordEventEmailChanged>(_emailChanged);
    on<ForgotPasswordEventSubmit>(_submit);
  }

  void _emailChanged(
    ForgotPasswordEventEmailChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  Future<void> _submit(
    ForgotPasswordEventSubmit event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emitLoadingStatus(emit);
    try {
      await _tryToSendPasswordResetEmail();
      emitCompleteStatus(emit, info: ForgotPasswordBlocInfo.emailSubmitted);
    } on AuthException catch (authException) {
      final ForgotPasswordBlocError? error = _mapAuthExceptionCodeToBlocError(
        authException.code,
      );
      if (error != null) {
        emitErrorStatus(emit, error);
      } else {
        emitUnknownErrorStatus(emit);
      }
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus(emit);
      }
    } on UnknownException catch (unknownException) {
      emitUnknownErrorStatus(emit);
      throw unknownException.message;
    }
  }

  Future<void> _tryToSendPasswordResetEmail() async {
    await _authService.sendPasswordResetEmail(
      email: state.email,
    );
  }

  ForgotPasswordBlocError? _mapAuthExceptionCodeToBlocError(
    AuthExceptionCode authExceptionCode,
  ) {
    if (authExceptionCode == AuthExceptionCode.invalidEmail) {
      return ForgotPasswordBlocError.invalidEmail;
    } else if (authExceptionCode == AuthExceptionCode.userNotFound) {
      return ForgotPasswordBlocError.userNotFound;
    }
    return null;
  }
}

enum ForgotPasswordBlocInfo { emailSubmitted }

enum ForgotPasswordBlocError { invalidEmail, userNotFound }
