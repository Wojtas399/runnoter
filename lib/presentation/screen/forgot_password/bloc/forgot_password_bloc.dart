import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/model/auth_exception.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import '../../../service/connectivity_service.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends BlocWithStatus<ForgotPasswordEvent,
    ForgotPasswordState, ForgotPasswordInfo, ForgotPasswordError> {
  final AuthService _authService;
  final ConnectivityService _connectivityService;

  ForgotPasswordBloc({
    required AuthService authService,
    required ConnectivityService connectivityService,
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
  })  : _authService = authService,
        _connectivityService = connectivityService,
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
    if (await _connectivityService.hasDeviceInternetConnection() == false) {
      emitNoInternetConnectionStatus(emit);
      return;
    }
    try {
      await _tryToSendPasswordResetEmail();
      emitCompleteStatus(emit, ForgotPasswordInfo.emailSubmitted);
    } on AuthException catch (authException) {
      final ForgotPasswordError? error = _mapAuthExceptionToBlocError(
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

  ForgotPasswordError? _mapAuthExceptionToBlocError(
    AuthException exception,
  ) {
    if (exception == AuthException.invalidEmail) {
      return ForgotPasswordError.invalidEmail;
    } else if (exception == AuthException.userNotFound) {
      return ForgotPasswordError.userNotFound;
    }
    return null;
  }
}
