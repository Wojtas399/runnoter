import 'package:equatable/equatable.dart';

abstract class CustomException<T> extends Equatable {
  final T code;
  final String? message;

  const CustomException({required this.code, this.message});

  @override
  List<Object?> get props => [code, message];
}

enum AuthExceptionCode {
  invalidEmail,
  wrongPassword,
  userNotFound,
  emailAlreadyInUse,
}

class AuthException extends CustomException<AuthExceptionCode> {
  const AuthException({required super.code});
}

enum CoachingRequestExceptionCode { userAlreadyHasCoach }

class CoachingRequestException
    extends CustomException<CoachingRequestExceptionCode> {
  const CoachingRequestException({required super.code});
}

enum EntityExceptionCode { entityNotFound, entityAlreadyExists }

class EntityException extends CustomException<EntityExceptionCode> {
  const EntityException({required super.code});
}

enum MessageImageExceptionCode { messageNotFound, listOfImageBytesIsEmpty }

class MessageImageException extends CustomException<MessageImageExceptionCode> {
  const MessageImageException({required super.code});
}

enum NetworkExceptionCode { requestFailed, tooManyRequests }

class NetworkException extends CustomException<NetworkExceptionCode> {
  const NetworkException({required super.code});
}

class UnknownException extends CustomException {
  const UnknownException({required super.message}) : super(code: null);
}
