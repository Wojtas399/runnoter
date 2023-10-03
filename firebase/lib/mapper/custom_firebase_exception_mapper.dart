import '../model/custom_firebase_exception.dart';

CustomFirebaseException mapFirebaseAuthExceptionFromCodeStr(String codeStr) =>
    (switch (codeStr) {
      'invalid-email' => const FirebaseAuthException(
          code: FirebaseAuthExceptionCode.invalidEmail,
        ),
      'user-not-found' => const FirebaseAuthException(
          code: FirebaseAuthExceptionCode.userNotFound,
        ),
      'wrong-password' => const FirebaseAuthException(
          code: FirebaseAuthExceptionCode.wrongPassword,
        ),
      'email-already-in-use' => const FirebaseAuthException(
          code: FirebaseAuthExceptionCode.emailAlreadyInUse,
        ),
      'network-request-failed' => const FirebaseNetworkException(
          code: FirebaseNetworkExceptionCode.requestFailed,
        ),
      'too-many-requests' => const FirebaseNetworkException(
          code: FirebaseNetworkExceptionCode.tooManyRequests,
        ),
      _ => FirebaseUnknownException(message: codeStr),
    }) as CustomFirebaseException;

CustomFirebaseException mapFirebaseExceptionFromCodeStr(String codeStr) =>
    (switch (codeStr) {
      'not-found' => const FirebaseDocumentException(
          code: FirebaseDocumentExceptionCode.documentNotFound,
        ),
      'network-request-failed' => const FirebaseNetworkException(
          code: FirebaseNetworkExceptionCode.requestFailed,
        ),
      'too-many-requests' => const FirebaseNetworkException(
          code: FirebaseNetworkExceptionCode.tooManyRequests,
        ),
      _ => FirebaseUnknownException(message: codeStr),
    }) as CustomFirebaseException;
