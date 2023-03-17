import '../model/exception/firebase_auth_exception_code.dart';

FirebaseAuthExceptionCode mapFirebaseAuthExceptionCodeToEnum(String code) {
  switch (code) {
    case 'invalid-email':
      return FirebaseAuthExceptionCode.invalidEmail;
    case 'user-not-found':
      return FirebaseAuthExceptionCode.userNotFound;
    case 'wrong-password':
      return FirebaseAuthExceptionCode.wrongPassword;
    case 'email-already-in-use':
      return FirebaseAuthExceptionCode.emailAlreadyInUse;
    default:
      return FirebaseAuthExceptionCode.unknown;
  }
}
