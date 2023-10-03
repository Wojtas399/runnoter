import 'package:firebase/mapper/custom_firebase_exception_mapper.dart';
import 'package:firebase/model/custom_firebase_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'mapFirebaseAuthExceptionFromCodeStr, '
    'invalid-email code should be mapped to FirebaseAuthException with invalidEmail code',
    () {
      const String codeStr = 'invalid-email';
      const CustomFirebaseException expectedException = FirebaseAuthException(
        code: FirebaseAuthExceptionCode.invalidEmail,
      );

      final CustomFirebaseException exception =
          mapFirebaseAuthExceptionFromCodeStr(codeStr);

      expect(exception, expectedException);
    },
  );

  test(
    'mapFirebaseAuthExceptionFromCodeStr, '
    'user-not-found code should be mapped to FirebaseAuthException with userNotFound code',
    () {
      const String codeStr = 'user-not-found';
      const CustomFirebaseException expectedException = FirebaseAuthException(
        code: FirebaseAuthExceptionCode.userNotFound,
      );

      final CustomFirebaseException exception =
          mapFirebaseAuthExceptionFromCodeStr(codeStr);

      expect(exception, expectedException);
    },
  );

  test(
    'mapFirebaseAuthExceptionFromCodeStr, '
    'wrong-password code should be mapped to FirebaseAuthException with wrongPassword code',
    () {
      const String codeStr = 'wrong-password';
      const CustomFirebaseException expectedException = FirebaseAuthException(
        code: FirebaseAuthExceptionCode.wrongPassword,
      );

      final CustomFirebaseException exception =
          mapFirebaseAuthExceptionFromCodeStr(codeStr);

      expect(exception, expectedException);
    },
  );

  test(
    'mapFirebaseAuthExceptionFromCodeStr, '
    'email-already-in-use code should be mapped to FirebaseAuthException with emailAlreadyInUse code',
    () {
      const String codeStr = 'email-already-in-use';
      const CustomFirebaseException expectedException = FirebaseAuthException(
        code: FirebaseAuthExceptionCode.emailAlreadyInUse,
      );

      final CustomFirebaseException exception =
          mapFirebaseAuthExceptionFromCodeStr(codeStr);

      expect(exception, expectedException);
    },
  );

  test(
    'mapFirebaseAuthExceptionFromCodeStr, '
    'network-request-failed code should be mapped to FirebaseNetworkException with requestFailed code',
    () {
      const String codeStr = 'network-request-failed';
      const CustomFirebaseException expectedException =
          FirebaseNetworkException(
        code: FirebaseNetworkExceptionCode.requestFailed,
      );

      final CustomFirebaseException exception =
          mapFirebaseAuthExceptionFromCodeStr(codeStr);

      expect(exception, expectedException);
    },
  );

  test(
    'mapFirebaseAuthExceptionFromCodeStr, '
    'unknown code should be mapped to FirebaseUnknownException with given code set as message',
    () {
      const String codeStr = 'unknown exception code';
      const CustomFirebaseException expectedException =
          FirebaseUnknownException(
        message: 'unknown exception code',
      );

      final CustomFirebaseException exception =
          mapFirebaseAuthExceptionFromCodeStr(codeStr);

      expect(exception, expectedException);
    },
  );

  test(
    'mapFirebaseExceptionFromCodeStr, '
    'document-not-found code should be mapped to FirebaseDbException with documentNotFound code',
    () {
      const String codeStr = 'not-found';
      const CustomFirebaseException expectedException = FirebaseDbException(
        code: FirebaseDbExceptionCode.documentNotFound,
      );

      final CustomFirebaseException exception =
          mapFirebaseExceptionFromCodeStr(codeStr);

      expect(exception, expectedException);
    },
  );

  test(
    'mapFirebaseExceptionFromCodeStr, '
    'network-request-failed code should be mapped to FirebaseNetworkException with requestFailed code',
    () {
      const String codeStr = 'network-request-failed';
      const CustomFirebaseException expectedException =
          FirebaseNetworkException(
        code: FirebaseNetworkExceptionCode.requestFailed,
      );

      final CustomFirebaseException exception =
          mapFirebaseExceptionFromCodeStr(codeStr);

      expect(exception, expectedException);
    },
  );

  test(
    'mapFirebaseExceptionFromCodeStr, '
    'unknown code should be mapped to FirebaseUnknownException with given code set as message',
    () {
      const String codeStr = 'unknown exception code';
      const CustomFirebaseException expectedException =
          FirebaseUnknownException(message: 'unknown exception code');

      final CustomFirebaseException exception =
          mapFirebaseExceptionFromCodeStr(codeStr);

      expect(exception, expectedException);
    },
  );
}
