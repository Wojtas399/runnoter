part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends CubitState<ForgotPasswordState> {
  final String email;

  const ForgotPasswordState({required super.status, this.email = ''});

  @override
  List<Object> get props => [status, email];

  bool get isSubmitButtonDisabled => email.isEmpty;

  @override
  ForgotPasswordState copyWith({CubitStatus? status, String? email}) =>
      ForgotPasswordState(
        status: status ?? const CubitStatusComplete(),
        email: email ?? this.email,
      );
}
