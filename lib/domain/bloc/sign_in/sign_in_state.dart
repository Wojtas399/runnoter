part of 'sign_in_bloc.dart';

enum SignInInfo {
  signedIn,
}

enum SignInError {
  invalidEmail,
  userNotFound,
  wrongPassword,
}

class SignInState extends BlocState {
  final String email;
  final String password;

  const SignInState({
    required super.status,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        status,
        email,
        password,
      ];

  bool get isButtonDisabled => email.isEmpty || password.isEmpty;

  @override
  SignInState copyWith({
    BlocStatus? status,
    String? email,
    String? password,
  }) {
    return SignInState(
      status: status ?? const BlocStatusComplete(),
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
