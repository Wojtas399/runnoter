import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/auth_exception_mapper.dart';
import 'package:runnoter/domain/additional_model/auth_exception.dart';

void main() {
  group(
    'map from firebase auth exception code to auth exception',
    () {
      test(
        'firebase auth exception invalid email code should be mapped to auth exception with invalidEmail type',
        () {
          const firebaseAuthExceptionCode =
              FirebaseAuthExceptionCode.invalidEmail;
          const expectedAuthException = AuthException.invalidEmail;

          final exception = mapFromFirebaseAuthExceptionCodeToAuthException(
            firebaseAuthExceptionCode,
          );

          expect(exception, expectedAuthException);
        },
      );

      test(
        'firebase auth exception wrong password code should be mapped to auth exception with wrongPassword type',
        () {
          const firebaseAuthExceptionCode =
              FirebaseAuthExceptionCode.wrongPassword;
          const expectedAuthException = AuthException.wrongPassword;

          final exception = mapFromFirebaseAuthExceptionCodeToAuthException(
            firebaseAuthExceptionCode,
          );

          expect(exception, expectedAuthException);
        },
      );

      test(
        'firebase auth exception user not found code should be mapped to auth exception with userNotFound type',
        () {
          const firebaseAuthExceptionCode =
              FirebaseAuthExceptionCode.userNotFound;
          const expectedAuthException = AuthException.userNotFound;

          final exception = mapFromFirebaseAuthExceptionCodeToAuthException(
            firebaseAuthExceptionCode,
          );

          expect(exception, expectedAuthException);
        },
      );

      test(
        'firebase auth exception email already in use code should be mapped to auth exception with emailAlreadyInUse type',
        () {
          const firebaseAuthExceptionCode =
              FirebaseAuthExceptionCode.emailAlreadyInUse;
          const expectedAuthException = AuthException.emailAlreadyInUse;

          final exception = mapFromFirebaseAuthExceptionCodeToAuthException(
            firebaseAuthExceptionCode,
          );

          expect(exception, expectedAuthException);
        },
      );
    },
  );
}
