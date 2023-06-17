sealed class FirebaseException {
  const FirebaseException();
}

enum FirebaseAuthExceptionCode {
  invalidEmail,
  userNotFound,
  wrongPassword,
  emailAlreadyInUse,
}

class FirebaseAuthException extends FirebaseException {
  final FirebaseAuthExceptionCode code;

  const FirebaseAuthException({
    required this.code,
  });
}

enum FirebaseNetworkExceptionCode {
  requestFailed,
}

class FirebaseNetworkException extends FirebaseException {
  final FirebaseNetworkExceptionCode code;

  const FirebaseNetworkException({
    required this.code,
  });
}

class FirebaseUnknownException extends FirebaseException {
  final String message;

  const FirebaseUnknownException({
    required this.message,
  });
}
