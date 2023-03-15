import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpEventNameChanged extends SignUpEvent {
  final String name;

  const SignUpEventNameChanged({
    required this.name,
  });

  @override
  List<Object> get props => [name];
}

class SignUpEventSurnameChanged extends SignUpEvent {
  final String surname;

  const SignUpEventSurnameChanged({
    required this.surname,
  });

  @override
  List<Object> get props => [surname];
}

class SignUpEventEmailChanged extends SignUpEvent {
  final String email;

  const SignUpEventEmailChanged({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}

class SignUpEventPasswordChanged extends SignUpEvent {
  final String password;

  const SignUpEventPasswordChanged({
    required this.password,
  });

  @override
  List<Object> get props => [password];
}

class SignUpEventPasswordConfirmationChanged extends SignUpEvent {
  final String passwordConfirmation;

  const SignUpEventPasswordConfirmationChanged({
    required this.passwordConfirmation,
  });

  @override
  List<Object> get props => [passwordConfirmation];
}

class SignUpEventSubmit extends SignUpEvent {
  const SignUpEventSubmit();
}
