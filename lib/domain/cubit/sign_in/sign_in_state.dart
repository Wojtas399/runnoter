part of 'sign_in_cubit.dart';

class SignInState extends CubitState<SignInState> {
  final String email;
  final String password;

  const SignInState({
    required super.status,
    this.email = '',
    this.password = '',
  });

  @override
  List<Object?> get props => [status, email, password];

  bool get isButtonDisabled => email.isEmpty || password.isEmpty;

  @override
  SignInState copyWith({
    CubitStatus? status,
    String? email,
    String? password,
  }) =>
      SignInState(
        status: status ?? const CubitStatusComplete(),
        email: email ?? this.email,
        password: password ?? this.password,
      );
}
