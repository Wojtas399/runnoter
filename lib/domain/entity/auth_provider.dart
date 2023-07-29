import 'package:equatable/equatable.dart';

sealed class AuthProvider extends Equatable {
  const AuthProvider();
}

class AuthProviderPassword extends AuthProvider {
  final String password;

  const AuthProviderPassword({required this.password});

  @override
  List<Object?> get props => [password];
}

class AuthProviderGoogle extends AuthProvider {
  const AuthProviderGoogle();

  @override
  List<Object?> get props => [];
}

class AuthProviderTwitter extends AuthProvider {
  const AuthProviderTwitter();

  @override
  List<Object?> get props => [];
}
