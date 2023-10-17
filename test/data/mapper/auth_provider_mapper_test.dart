import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/interface/service/auth_service.dart';
import 'package:runnoter/data/mapper/auth_provider_mapper.dart';

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

  test(
    'map auth provider to db, '
    'facebook, '
    'should map AuthProviderFacebook to FirebaseAuthProviderFacebook',
    () {
      const AuthProvider authProvider = AuthProviderFacebook();
      const FirebaseAuthProvider expectedFirebaseAuthProvider =
          FirebaseAuthProviderFacebook();

      final FirebaseAuthProvider firebaseAuthProvider = mapAuthProviderToDb(
        authProvider,
      );

      expect(firebaseAuthProvider, expectedFirebaseAuthProvider);
    },
  );
}
