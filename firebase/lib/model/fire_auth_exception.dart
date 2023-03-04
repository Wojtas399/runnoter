part of firebase_lib;

enum FireAuthExceptionCode {
  userNotFound,
  wrongPassword,
}

class FireAuthException {
  final FireAuthExceptionCode code;

  FireAuthException({
    required this.code,
  });
}
