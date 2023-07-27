import 'package:equatable/equatable.dart';

sealed class FirebaseAuthProvider extends Equatable {
  const FirebaseAuthProvider();
}

class FirebaseAuthProviderPassword extends FirebaseAuthProvider {
  final String password;

  const FirebaseAuthProviderPassword({required this.password});

  @override
  List<Object?> get props => [password];
}

class FirebaseAuthProviderGoogle extends FirebaseAuthProvider {
  const FirebaseAuthProviderGoogle();

  @override
  List<Object?> get props => [];
}
