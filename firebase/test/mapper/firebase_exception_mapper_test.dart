import 'package:firebase/mapper/firebase_exception_mapper.dart';
import 'package:firebase/model/firebase_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map firebase exception from code str, '
    'invalid-email code should be mapped to FirebaseAuthException with invalidEmail code',
    () {
      const String codeStr = 'invalid-email';
      const FirebaseException expectedException = FirebaseAuthException(
        code: FirebaseAuthExceptionCode.invalidEmail,
      );

      final FirebaseException exception = mapFirebaseExceptionFromCodeStr(
        codeStr,
      );

      expect(exception, expectedException);
    },
  );

  test(
    'map firebase exception from code str, '
    'user-not-found code should be mapped to FirebaseAuthException with userNotFound code',
    () {
      const String codeStr = 'user-not-found';
      const FirebaseException expectedException = FirebaseAuthException(
        code: FirebaseAuthExceptionCode.userNotFound,
      );

      final FirebaseException exception = mapFirebaseExceptionFromCodeStr(
        codeStr,
      );

      expect(exception, expectedException);
    },
  );

  test(
    'map firebase exception from code str, '
    'wrong-password code should be mapped to FirebaseAuthException with wrongPassword code',
    () {
      const String codeStr = 'wrong-password';
      const FirebaseException expectedException = FirebaseAuthException(
        code: FirebaseAuthExceptionCode.wrongPassword,
      );

      final FirebaseException exception = mapFirebaseExceptionFromCodeStr(
        codeStr,
      );

      expect(exception, expectedException);
    },
  );

  test(
    'map firebase exception from code str, '
    'email-already-in-use code should be mapped to FirebaseAuthException with emailAlreadyInUse code',
    () {
      const String codeStr = 'email-already-in-use';
      const FirebaseException expectedException = FirebaseAuthException(
        code: FirebaseAuthExceptionCode.emailAlreadyInUse,
      );

      final FirebaseException exception = mapFirebaseExceptionFromCodeStr(
        codeStr,
      );

      expect(exception, expectedException);
    },
  );

  test(
    'map firebase exception from code str, '
    'network-request-failed code should be mapped to FirebaseNetworkException with requestFailed code',
    () {
      const String codeStr = 'network-request-failed';
      const FirebaseException expectedException = FirebaseNetworkException(
        code: FirebaseNetworkExceptionCode.requestFailed,
      );

      final FirebaseException exception = mapFirebaseExceptionFromCodeStr(
        codeStr,
      );

      expect(exception, expectedException);
    },
  );

  test(
    'map firebase exception from code str, '
    'unknown code should be mapped to FirebaseUnknownException with given code set as message',
    () {
      const String codeStr = 'unknown exception code';
      const FirebaseException expectedException = FirebaseUnknownException(
        message: 'unknown exception code',
      );

      final FirebaseException exception = mapFirebaseExceptionFromCodeStr(
        codeStr,
      );

      expect(exception, expectedException);
    },
  );
}
