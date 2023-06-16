import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/additional_model/auth_exception.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/service/auth_service.dart';
import '../../additional_model/bloc_state.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends BlocWithStatus<ForgotPasswordEvent,
    ForgotPasswordState, ForgotPasswordBlocInfo, ForgotPasswordBlocError> {
  final AuthService _authService;
  ForgotPasswordBloc({
    required AuthService authService,
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
  })  : _authService = authService,
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
      emitCompleteStatus(emit, ForgotPasswordBlocInfo.emailSubmitted);
    } on AuthException catch (authException) {
      if (authException == AuthException.networkRequestFailed) {
        emitNetworkRequestFailed(emit);
        return;
      }
      final ForgotPasswordBlocError? error = _mapAuthExceptionToBlocError(
        authException,
      );
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

  Future<void> _tryToSendPasswordResetEmail() async {
    await _authService.sendPasswordResetEmail(
      email: state.email,
    );
  }

  ForgotPasswordBlocError? _mapAuthExceptionToBlocError(
    AuthException exception,
  ) {
    if (exception == AuthException.invalidEmail) {
      return ForgotPasswordBlocError.invalidEmail;
    } else if (exception == AuthException.userNotFound) {
      return ForgotPasswordBlocError.userNotFound;
    }
    return null;
  }
}

enum ForgotPasswordBlocInfo {
  emailSubmitted,
}

enum ForgotPasswordBlocError {
  invalidEmail,
  userNotFound,
}
