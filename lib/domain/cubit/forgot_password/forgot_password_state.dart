part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends CubitState {
  final String email;

  const ForgotPasswordState({required super.status, this.email = ''});

  @override
  List<Object> get props => [status, email];

  bool get isSubmitButtonDisabled => email.isEmpty;

  @override
  ForgotPasswordState copyWith({
    BlocStatus? status,
    String? email,
  }) =>
      ForgotPasswordState(
        status: status ?? const BlocStatusComplete(),
        email: email ?? this.email,
      );
}
