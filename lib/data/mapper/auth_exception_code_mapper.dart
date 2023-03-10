import '../../domain/model/auth_exception.dart';

class AuthExceptionCodeMapper {
  AuthExceptionCode? mapFromFirebaseCodeToDomainCode({
    required String firebaseAuthExceptionCode,
  }) {
    switch (firebaseAuthExceptionCode) {
      case 'invalid-email':
        return AuthExceptionCode.invalidEmail;
      case 'wrong-password':
        return AuthExceptionCode.wrongPassword;
      case 'user-not-found':
        return AuthExceptionCode.userNotFound;
      case 'email-already-in-use':
        return AuthExceptionCode.emailAlreadyInUse;
      default:
        return null;
    }
  }
}
