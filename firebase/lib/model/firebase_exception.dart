import 'package:equatable/equatable.dart';

sealed class FirebaseException extends Equatable {
  const FirebaseException();
}

enum FirebaseAuthExceptionCode {
  invalidEmail,
  userNotFound,
  wrongPassword,
  emailAlreadyInUse,
  userMismatch,
  socialAuthenticationCancelled,
}

class FirebaseAuthException extends FirebaseException {
  final FirebaseAuthExceptionCode code;

  const FirebaseAuthException({
    required this.code,
  });

  @override
  List<Object?> get props => [
        code,
      ];
}

enum FirebaseNetworkExceptionCode {
  requestFailed,
  tooManyRequests,
}

class FirebaseNetworkException extends FirebaseException {
  final FirebaseNetworkExceptionCode code;

  const FirebaseNetworkException({
    required this.code,
  });

  @override
  List<Object?> get props => [
        code,
      ];
}

class FirebaseUnknownException extends FirebaseException {
  final String message;

  const FirebaseUnknownException({
    required this.message,
  });

  @override
  List<Object?> get props => [
        message,
      ];
}
