part of 'sign_in_cubit.dart';

class SignInState extends CubitState {
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
    BlocStatus? status,
    String? email,
    String? password,
  }) =>
      SignInState(
        status: status ?? const BlocStatusComplete(),
        email: email ?? this.email,
        password: password ?? this.password,
      );
}
