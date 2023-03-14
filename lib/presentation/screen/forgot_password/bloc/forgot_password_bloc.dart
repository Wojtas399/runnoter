import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/model/auth_exception.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends BlocWithStatus<ForgotPasswordEvent,
    ForgotPasswordState, ForgotPasswordInfo, ForgotPasswordError> {
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
    try {
      emitLoadingStatus(emit);
      await _authService.sendPasswordResetEmail(
        email: state.email,
      );
      emitCompleteStatus(emit, ForgotPasswordInfo.emailSubmitted);
    } on AuthException catch (authException) {
      if (authException == AuthException.invalidEmail) {
        emitErrorStatus(emit, ForgotPasswordError.invalidEmail);
      } else if (authException == AuthException.userNotFound) {
        emitErrorStatus(emit, ForgotPasswordError.userNotFound);
      }
    }
  }
}
