import 'package:equatable/equatable.dart';

enum AuthExceptionCode {
  invalidEmail,
  wrongPassword,
  userNotFound,
  emailAlreadyInUse,
}

class AuthException extends Equatable {
  final AuthExceptionCode code;

  const AuthException({
    required this.code,
  });

  @override
  List<Object> get props => [
        code,
      ];
}
