part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

class ForgotPasswordEventEmailChanged extends ForgotPasswordEvent {
  final String email;

  const ForgotPasswordEventEmailChanged({
    required this.email,
  });
}

class ForgotPasswordEventSubmit extends ForgotPasswordEvent {
  const ForgotPasswordEventSubmit();
}
