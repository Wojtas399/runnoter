import 'package:equatable/equatable.dart';

sealed class FirebaseException<T> extends Equatable {
  final T code;
  final String? message;

  const FirebaseException({required this.code, this.message});

  @override
  List<Object?> get props => [code, message];
}

enum FirebaseAuthExceptionCode {
  invalidEmail,
  userNotFound,
  wrongPassword,
  emailAlreadyInUse
}

class FirebaseAuthException
    extends FirebaseException<FirebaseAuthExceptionCode> {
  const FirebaseAuthException({required super.code});
}

enum FirebaseChatExceptionCode { chatAlreadyExists }

class FirebaseChatException
    extends FirebaseException<FirebaseChatExceptionCode> {
  const FirebaseChatException({required super.code});
}

enum FirebaseNetworkExceptionCode { requestFailed, tooManyRequests }

class FirebaseNetworkException
    extends FirebaseException<FirebaseNetworkExceptionCode> {
  const FirebaseNetworkException({required super.code});
}

class FirebaseUnknownException extends FirebaseException {
  const FirebaseUnknownException({required super.message}) : super(code: null);
}
