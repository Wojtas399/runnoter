import 'package:firebase/firebase.dart';
import 'package:firebase/mapper/firebase_auth_exception_code_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'invalid-email code should be mapped to invalidEmail enum',
    () {
      const code = 'invalid-email';
      const authException = FirebaseAuthExceptionCode.invalidEmail;

      final FirebaseAuthExceptionCode mappedValue =
          mapFirebaseAuthExceptionCodeToEnum(code);

      expect(mappedValue, authException);
    },
  );

  test(
    'user-not-found code should be mapped to userNotFound enum',
    () {
      const code = 'user-not-found';
      const authException = FirebaseAuthExceptionCode.userNotFound;

      final FirebaseAuthExceptionCode mappedValue =
          mapFirebaseAuthExceptionCodeToEnum(code);

      expect(mappedValue, authException);
    },
  );

  test(
    'wrong-password code should be mapped to wrongPassword enum',
    () {
      const code = 'wrong-password';
      const authException = FirebaseAuthExceptionCode.wrongPassword;

      final FirebaseAuthExceptionCode mappedValue =
          mapFirebaseAuthExceptionCodeToEnum(code);

      expect(mappedValue, authException);
    },
  );

  test(
    'email-already-in-use code should be mapped to emailAlreadyInUse enum',
    () {
      const code = 'email-already-in-use';
      const authException = FirebaseAuthExceptionCode.emailAlreadyInUse;

      final FirebaseAuthExceptionCode mappedValue =
          mapFirebaseAuthExceptionCodeToEnum(code);

      expect(mappedValue, authException);
    },
  );

  test(
    'should return unknown enum as default',
    () {
      const code = 'something';
      const authException = FirebaseAuthExceptionCode.unknown;

      final FirebaseAuthExceptionCode mappedValue =
          mapFirebaseAuthExceptionCodeToEnum(code);

      expect(mappedValue, authException);
    },
  );
}
