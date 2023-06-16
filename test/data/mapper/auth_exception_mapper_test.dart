import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/auth_exception_mapper.dart';
import 'package:runnoter/domain/additional_model/auth_exception.dart';

void main() {
  test(
    'map from firebase auth exception'
    'FirebaseAuthException.invalidEmail code should be mapped to AuthException.invalidEmail',
    () {
      const firebaseAuthExceptionCode = FirebaseAuthExceptionCode.invalidEmail;
      const expectedAuthException = AuthException.invalidEmail;

      final exception = mapFromFirebaseAuthException(firebaseAuthExceptionCode);

      expect(exception, expectedAuthException);
    },
  );

  test(
    'map from firebase auth exception'
    'FirebaseAuthException.wrongPassword should be mapped to AuthException.wrongPassword',
    () {
      const firebaseAuthExceptionCode = FirebaseAuthExceptionCode.wrongPassword;
      const expectedAuthException = AuthException.wrongPassword;

      final exception = mapFromFirebaseAuthException(firebaseAuthExceptionCode);

      expect(exception, expectedAuthException);
    },
  );

  test(
    'map from firebase auth exception'
    'FirebaseAuthException.userNotFound should be mapped to AuthException.userNotFound',
    () {
      const firebaseAuthExceptionCode = FirebaseAuthExceptionCode.userNotFound;
      const expectedAuthException = AuthException.userNotFound;

      final exception = mapFromFirebaseAuthException(firebaseAuthExceptionCode);

      expect(exception, expectedAuthException);
    },
  );

  test(
    'map from firebase auth exception'
    'FirebaseAuthException.emailAlreadyInUse should be mapped to AuthException.emailAlreadyInUse',
    () {
      const firebaseAuthExceptionCode =
          FirebaseAuthExceptionCode.emailAlreadyInUse;
      const expectedAuthException = AuthException.emailAlreadyInUse;

      final exception = mapFromFirebaseAuthException(firebaseAuthExceptionCode);

      expect(exception, expectedAuthException);
    },
  );
}
