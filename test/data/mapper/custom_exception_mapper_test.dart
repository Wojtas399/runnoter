import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/custom_exception_mapper.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';

void main() {
  test(
    'map exception from firebase, '
    'FirebaseAuthException with invalidEmail code should be mapped to AuthException with invalidEmail code',
    () {
      const FirebaseException firebaseException = FirebaseAuthException(
        code: FirebaseAuthExceptionCode.invalidEmail,
      );
      const CustomException expectedException = AuthException(
        code: AuthExceptionCode.invalidEmail,
      );

      final CustomException exception = mapExceptionFromFirebase(
        firebaseException,
      );

      expect(exception, expectedException);
    },
  );

  test(
    'map exception from firebase, '
    'FirebaseAuthException with emailAlreadyInUse code should be mapped to AuthException with emailAlreadyInUse code',
    () {
      const FirebaseException firebaseException = FirebaseAuthException(
        code: FirebaseAuthExceptionCode.emailAlreadyInUse,
      );
      const CustomException expectedException = AuthException(
        code: AuthExceptionCode.emailAlreadyInUse,
      );

      final CustomException exception = mapExceptionFromFirebase(
        firebaseException,
      );

      expect(exception, expectedException);
    },
  );

  test(
    'map exception from firebase, '
    'FirebaseAuthException with userNotFound code should be mapped to AuthException with userNotFound code',
    () {
      const FirebaseException firebaseException = FirebaseAuthException(
        code: FirebaseAuthExceptionCode.userNotFound,
      );
      const CustomException expectedException = AuthException(
        code: AuthExceptionCode.userNotFound,
      );

      final CustomException exception = mapExceptionFromFirebase(
        firebaseException,
      );

      expect(exception, expectedException);
    },
  );

  test(
    'map exception from firebase, '
    'FirebaseAuthException with wrongPassword code should be mapped to AuthException with wrongPassword code',
    () {
      const FirebaseException firebaseException = FirebaseAuthException(
        code: FirebaseAuthExceptionCode.wrongPassword,
      );
      const CustomException expectedException = AuthException(
        code: AuthExceptionCode.wrongPassword,
      );

      final CustomException exception = mapExceptionFromFirebase(
        firebaseException,
      );

      expect(exception, expectedException);
    },
  );

  test(
    'map exception from firebase, '
    'FirebaseNetworkException with requestFailed code should be mapped to NetworkException with requestFailed code',
    () {
      const FirebaseException firebaseException = FirebaseNetworkException(
        code: FirebaseNetworkExceptionCode.requestFailed,
      );
      const CustomException expectedException = NetworkException(
        code: NetworkExceptionCode.requestFailed,
      );

      final CustomException exception = mapExceptionFromFirebase(
        firebaseException,
      );

      expect(exception, expectedException);
    },
  );

  test(
    'map exception from firebase, '
    'FirebaseUnknownException should be mapped to UnknownException',
    () {
      const FirebaseException firebaseException = FirebaseUnknownException(
        message: 'unknown exception',
      );
      const CustomException expectedException = UnknownException(
        message: 'unknown exception',
      );

      final CustomException exception = mapExceptionFromFirebase(
        firebaseException,
      );

      expect(exception, expectedException);
    },
  );
}
