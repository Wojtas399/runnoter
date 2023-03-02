part of 'sign_in_bloc.dart';

class SignInState extends BlocState {
  final String? email;
  final String? password;

  const SignInState({
    required super.status,
    this.email,
    this.password,
  });

  @override
  List<Object?> get props => [
        status,
        email,
        password,
      ];

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
