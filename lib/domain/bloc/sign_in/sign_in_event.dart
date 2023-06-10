part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInEventInitialize extends SignInEvent {
  const SignInEventInitialize();
}

class SignInEventEmailChanged extends SignInEvent {
  final String email;

  const SignInEventEmailChanged({
    required this.email,
  });

  @override
  List<Object> get props => [
        email,
      ];
}

class SignInEventPasswordChanged extends SignInEvent {
  final String password;

  const SignInEventPasswordChanged({
    required this.password,
  });

  @override
  List<Object> get props => [
        password,
      ];
}

class SignInEventSubmit extends SignInEvent {
  const SignInEventSubmit();
}
