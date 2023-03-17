import 'package:firebase/firebase.dart';

import '../../domain/model/auth_exception.dart';

AuthException? mapFromFirebaseAuthExceptionCodeToAuthException(
  FirebaseAuthExceptionCode firebaseAuthExceptionCode,
) {
  switch (firebaseAuthExceptionCode) {
    case FirebaseAuthExceptionCode.invalidEmail:
      return AuthException.invalidEmail;
    case FirebaseAuthExceptionCode.wrongPassword:
      return AuthException.wrongPassword;
    case FirebaseAuthExceptionCode.userNotFound:
      return AuthException.userNotFound;
    case FirebaseAuthExceptionCode.emailAlreadyInUse:
      return AuthException.emailAlreadyInUse;
    default:
      return null;
  }
}
