import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runnoter/model/bloc_state.dart';
import 'package:runnoter/model/bloc_status.dart';
import 'package:runnoter/model/bloc_with_status.dart';
import 'package:runnoter/presentation/service/validation_service.dart'
    as validator;

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc
    extends BlocWithStatus<SignUpEvent, SignUpState, dynamic, dynamic> {
  SignUpBloc({
    BlocStatus status = const BlocStatusInitial(),
    String name = '',
    String surname = '',
    String email = '',
    String password = '',
    String passwordConfirmation = '',
  }) : super(
          SignUpState(
            status: status,
            name: name,
            surname: surname,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
          ),
        ) {
    on<SignUpEventNameChanged>(_nameChanged);
    on<SignUpEventSurnameChanged>(_surnameChanged);
    on<SignUpEventEmailChanged>(_emailChanged);
    on<SignUpEventPasswordChanged>(_passwordChanged);
    on<SignUpEventPasswordConfirmationChanged>(_passwordConfirmationChanged);
    on<SignUpEventSubmit>(_submit);
  }

  void _nameChanged(
    SignUpEventNameChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      name: event.name,
    ));
  }

  void _surnameChanged(
    SignUpEventSurnameChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      surname: event.surname,
    ));
  }

  void _emailChanged(
    SignUpEventEmailChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  void _passwordChanged(
    SignUpEventPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
    ));
  }

  void _passwordConfirmationChanged(
    SignUpEventPasswordConfirmationChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      passwordConfirmation: event.passwordConfirmation,
    ));
  }

  Future<void> _submit(
    SignUpEventSubmit event,
    Emitter<SignUpState> emit,
  ) async {
    //TODO: Connect sign up method
  }
}
