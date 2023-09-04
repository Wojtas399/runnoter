import '../model/firebase_exception.dart';

FirebaseException mapFirebaseExceptionFromCodeStr(String codeStr) {
  return (switch (codeStr) {
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
  }) as FirebaseException;
}
