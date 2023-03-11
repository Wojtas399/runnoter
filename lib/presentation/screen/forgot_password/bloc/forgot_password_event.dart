import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class ForgotPasswordEventEmailChanged extends ForgotPasswordEvent {
  final String email;

  const ForgotPasswordEventEmailChanged({
    required this.email,
  });

  @override
  List<Object> get props => [
        email,
      ];
}

class ForgotPasswordEventSubmit extends ForgotPasswordEvent {
  const ForgotPasswordEventSubmit();
}
