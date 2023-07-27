import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/auth_provider_mapper.dart';
import 'package:runnoter/domain/entity/auth_provider.dart';

void main() {
  test(
    'map auth provider to db, '
    'password, '
    'should map AuthProviderPassword to FirebaseAuthProviderPassword',
    () {
      const String password = 'passwd';
      const AuthProvider authProvider = AuthProviderPassword(
        password: password,
      );
      const FirebaseAuthProvider expectedFirebaseAuthProvider =
          FirebaseAuthProviderPassword(password: password);

      final FirebaseAuthProvider firebaseAuthProvider = mapAuthProviderToDb(
        authProvider,
      );

      expect(firebaseAuthProvider, expectedFirebaseAuthProvider);
    },
  );

  test(
    'map auth provider to db, '
    'google, '
    'should map AuthProviderGoogle to FirebaseAuthProviderGoogle',
    () {
      const AuthProvider authProvider = AuthProviderGoogle();
      const FirebaseAuthProvider expectedFirebaseAuthProvider =
          FirebaseAuthProviderGoogle();

      final FirebaseAuthProvider firebaseAuthProvider = mapAuthProviderToDb(
        authProvider,
      );

      expect(firebaseAuthProvider, expectedFirebaseAuthProvider);
    },
  );
}
