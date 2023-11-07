import 'package:equatable/equatable.dart';

sealed class FirebaseAuthProvider extends Equatable {
  const FirebaseAuthProvider();

  @override
  List<Object?> get props => [];
}

class FirebaseAuthProviderPassword extends FirebaseAuthProvider {
  final String password;

  const FirebaseAuthProviderPassword({required this.password});

  @override
  List<Object?> get props => [password];
}

class FirebaseAuthProviderGoogle extends FirebaseAuthProvider {
  const FirebaseAuthProviderGoogle();
}

class FirebaseAuthProviderFacebook extends FirebaseAuthProvider {
  const FirebaseAuthProviderFacebook();
}

class FirebaseAuthProviderApple extends FirebaseAuthProvider {
  const FirebaseAuthProviderApple();
}
