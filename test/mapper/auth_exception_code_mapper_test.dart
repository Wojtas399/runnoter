import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/mapper/auth_exception_code_mapper.dart';
import 'package:runnoter/model/auth_exception.dart';

void main() {
  final mapper = AuthExceptionCodeMapper();

  group(
    "map from firebase code to domain code",
    () {
      AuthExceptionCode? callMethod({
        required String firebaseCode,
      }) {
        return mapper.mapFromFirebaseCodeToDomainCode(
          firebaseAuthExceptionCode: firebaseCode,
        );
      }

      test(
        "firebase invalid email code should be mapped to domain invalid email code",
        () {
          const String firebaseCode = 'invalid-email';
          const AuthExceptionCode domainCode = AuthExceptionCode.invalidEmail;

          final mappedCode = callMethod(firebaseCode: firebaseCode);

          expect(mappedCode, domainCode);
        },
      );

      test(
        "firebase wrong password code should be mapped to domain wrong password code",
        () {
          const String firebaseCode = 'wrong-password';
          const AuthExceptionCode domainCode = AuthExceptionCode.wrongPassword;

          final mappedCode = callMethod(firebaseCode: firebaseCode);

          expect(mappedCode, domainCode);
        },
      );

      test(
        "firebase user not found code should be mapped to domain user not found code",
        () {
          const String firebaseCode = 'user-not-found';
          const AuthExceptionCode domainCode = AuthExceptionCode.userNotFound;

          final mappedCode = callMethod(firebaseCode: firebaseCode);

          expect(mappedCode, domainCode);
        },
      );

      test(
        "firebase email already taken code should be mapped to domain email already taken code",
        () {
          const String firebaseCode = 'email-already-taken';
          const AuthExceptionCode domainCode =
              AuthExceptionCode.emailAlreadyTaken;

          final mappedCode = callMethod(firebaseCode: firebaseCode);

          expect(mappedCode, domainCode);
        },
      );
    },
  );
}
