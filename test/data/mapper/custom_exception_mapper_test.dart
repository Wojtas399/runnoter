import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/additional_model/custom_exception.dart';
import 'package:runnoter/data/mapper/custom_exception_mapper.dart';

void main() {
  test(
    'mapExceptionFromDb, '
    'FirebaseAuthException with invalidEmail code should be mapped to AuthException with invalidEmail code',
    () {
      const CustomFirebaseException firebaseException = FirebaseAuthException(
        code: FirebaseAuthExceptionCode.invalidEmail,
      );
      const CustomException expectedException = AuthException(
        code: AuthExceptionCode.invalidEmail,
      );

      final CustomException exception = mapExceptionFromDb(
        firebaseException,
      );

      expect(exception, expectedException);
    },
  );

  test(
    'mapExceptionFromDb, '
    'FirebaseAuthException with emailAlreadyInUse code should be mapped to AuthException with emailAlreadyInUse code',
    () {
      const CustomFirebaseException firebaseException = FirebaseAuthException(
        code: FirebaseAuthExceptionCode.emailAlreadyInUse,
      );
      const CustomException expectedException = AuthException(
        code: AuthExceptionCode.emailAlreadyInUse,
      );

      final CustomException exception = mapExceptionFromDb(firebaseException);

      expect(exception, expectedException);
    },
  );

  test(
    'mapExceptionFromDb, '
    'FirebaseAuthException with userNotFound code should be mapped to AuthException with userNotFound code',
    () {
      const CustomFirebaseException firebaseException = FirebaseAuthException(
        code: FirebaseAuthExceptionCode.userNotFound,
      );
      const CustomException expectedException = AuthException(
        code: AuthExceptionCode.userNotFound,
      );

      final CustomException exception = mapExceptionFromDb(firebaseException);

      expect(exception, expectedException);
    },
  );

  test(
    'mapExceptionFromDb, '
    'FirebaseAuthException with wrongPassword code should be mapped to AuthException with wrongPassword code',
    () {
      const CustomFirebaseException firebaseException = FirebaseAuthException(
        code: FirebaseAuthExceptionCode.wrongPassword,
      );
      const CustomException expectedException = AuthException(
        code: AuthExceptionCode.wrongPassword,
      );

      final CustomException exception = mapExceptionFromDb(firebaseException);

      expect(exception, expectedException);
    },
  );

  test(
    'mapExceptionFromDb, '
    'FirebaseDocumentException with documentNotFound code should be mapped to EntityException with entityNotFound code',
    () {
      const CustomFirebaseException firebaseException =
          FirebaseDocumentException(
        code: FirebaseDocumentExceptionCode.documentNotFound,
      );
      const CustomException expectedException = EntityException(
        code: EntityExceptionCode.entityNotFound,
      );

      final CustomException exception = mapExceptionFromDb(firebaseException);

      expect(exception, expectedException);
    },
  );

  test(
    'mapExceptionFromDb, '
    'FirebaseDocumentException with documentAlreadyExists code should be mapped to EntityException with entityAlreadyExists code',
    () {
      const CustomFirebaseException firebaseException =
          FirebaseDocumentException(
        code: FirebaseDocumentExceptionCode.documentAlreadyExists,
      );
      const CustomException expectedException = EntityException(
        code: EntityExceptionCode.entityAlreadyExists,
      );

      final CustomException exception = mapExceptionFromDb(firebaseException);

      expect(exception, expectedException);
    },
  );

  test(
    'mapExceptionFromDb, '
    'FirebaseNetworkException with requestFailed code should be mapped to NetworkException with requestFailed code',
    () {
      const CustomFirebaseException firebaseException =
          FirebaseNetworkException(
        code: FirebaseNetworkExceptionCode.requestFailed,
      );
      const CustomException expectedException = NetworkException(
        code: NetworkExceptionCode.requestFailed,
      );

      final CustomException exception = mapExceptionFromDb(firebaseException);

      expect(exception, expectedException);
    },
  );

  test(
    'mapExceptionFromDb, '
    'FirebaseNetworkException with tooManyRequests code should be mapped to NetworkException with tooManyRequests code',
    () {
      const CustomFirebaseException firebaseException =
          FirebaseNetworkException(
        code: FirebaseNetworkExceptionCode.tooManyRequests,
      );
      const CustomException expectedException = NetworkException(
        code: NetworkExceptionCode.tooManyRequests,
      );

      final CustomException exception = mapExceptionFromDb(firebaseException);

      expect(exception, expectedException);
    },
  );

  test(
    'mapExceptionFromDb, '
    'FirebaseUnknownException should be mapped to UnknownException',
    () {
      const CustomFirebaseException firebaseException =
          FirebaseUnknownException(
        message: 'unknown exception',
      );
      const CustomException expectedException = UnknownException(
        message: 'unknown exception',
      );

      final CustomException exception = mapExceptionFromDb(firebaseException);

      expect(exception, expectedException);
    },
  );
}
