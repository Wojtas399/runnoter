import 'package:equatable/equatable.dart';

abstract class CustomException extends Equatable {
  const CustomException();
}

enum AuthExceptionCode {
  invalidEmail,
  wrongPassword,
  userNotFound,
  emailAlreadyInUse,
  userMismatch,
  socialAuthenticationCancelled,
}

class AuthException extends CustomException {
  final AuthExceptionCode code;

  const AuthException({
    required this.code,
  });

  @override
  List<Object?> get props => [
        code,
      ];
}

enum NetworkExceptionCode {
  requestFailed,
  tooManyRequests,
}

class NetworkException extends CustomException {
  final NetworkExceptionCode code;

  const NetworkException({
    required this.code,
  });

  @override
  List<Object?> get props => [
        code,
      ];
}

class UnknownException extends CustomException {
  final String message;

  const UnknownException({
    required this.message,
  });

  @override
  List<Object?> get props => [
        message,
      ];
}
