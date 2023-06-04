part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends BlocState {
  final String email;

  const ForgotPasswordState({
    required super.status,
    required this.email,
  });

  @override
  List<Object> get props => [
        status,
        email,
      ];

  bool get isSubmitButtonDisabled => email.isEmpty;

  @override
  ForgotPasswordState copyWith({
    BlocStatus? status,
    String? email,
  }) {
    return ForgotPasswordState(
      status: status ?? const BlocStatusComplete(),
      email: email ?? this.email,
    );
  }
}