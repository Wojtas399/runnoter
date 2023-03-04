import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends BlocWithStatus<SignInEvent, SignInState> {
  SignInBloc({
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
    String password = '',
  }) : super(
          SignInState(
            status: status,
            email: email,
            password: password,
          ),
        ) {
    on<SignInEventEmailChanged>(_emailChanged);
    on<SignInEventPasswordChanged>(_passwordChanged);
    on<SignInEventSubmit>(_submit);
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
    //TODO
  }
}
