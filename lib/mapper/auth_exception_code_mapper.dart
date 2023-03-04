import '../../model/auth_exception.dart';

class AuthExceptionCodeMapper {
  AuthExceptionCode? mapFromFirebaseCodeToDomainCode({
    required String firebaseAuthExceptionCode,
  }) {
    switch (firebaseAuthExceptionCode) {
      case 'wrong-password':
        return AuthExceptionCode.wrongPassword;
      case 'user-not-found':
        return AuthExceptionCode.userNotFound;
      case 'email-already-taken':
        return AuthExceptionCode.emailAlreadyTaken;
      default:
        return null;
    }
  }
}
