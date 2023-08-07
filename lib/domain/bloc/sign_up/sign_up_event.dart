part of 'sign_up_bloc.dart';

abstract class SignUpEvent {
  const SignUpEvent();
}

class SignUpEventAccountTypeChanged extends SignUpEvent {
  final AccountType accountType;

  const SignUpEventAccountTypeChanged({required this.accountType});
}

class SignUpEventGenderChanged extends SignUpEvent {
  final Gender gender;

  const SignUpEventGenderChanged({required this.gender});
}

class SignUpEventNameChanged extends SignUpEvent {
  final String name;

  const SignUpEventNameChanged({required this.name});
}

class SignUpEventSurnameChanged extends SignUpEvent {
  final String surname;

  const SignUpEventSurnameChanged({required this.surname});
}

class SignUpEventEmailChanged extends SignUpEvent {
  final String email;

  const SignUpEventEmailChanged({required this.email});
}

class SignUpEventPasswordChanged extends SignUpEvent {
  final String password;

  const SignUpEventPasswordChanged({required this.password});
}

class SignUpEventPasswordConfirmationChanged extends SignUpEvent {
  final String passwordConfirmation;

  const SignUpEventPasswordConfirmationChanged({
    required this.passwordConfirmation,
  });
}

class SignUpEventSubmit extends SignUpEvent {
  const SignUpEventSubmit();
}
