import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends BlocWithStatus<ForgotPasswordEvent,
    ForgotPasswordState, ForgotPasswordInfo, ForgotPasswordError> {
  ForgotPasswordBloc({
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
  }) : super(
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

  void _submit(
    ForgotPasswordEventSubmit event,
    Emitter<ForgotPasswordState> emit,
  ) {
    //TODO
  }
}
