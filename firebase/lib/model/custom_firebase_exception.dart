import 'package:equatable/equatable.dart';

sealed class CustomFirebaseException<T> extends Equatable {
  final T code;
  final String? message;

  const CustomFirebaseException({required this.code, this.message});

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
    extends CustomFirebaseException<FirebaseAuthExceptionCode> {
  const FirebaseAuthException({required super.code});
}

enum FirebaseDbExceptionCode { documentNotFound, documentAlreadyExists }

class FirebaseDbException
    extends CustomFirebaseException<FirebaseDbExceptionCode> {
  const FirebaseDbException({required super.code});
}

enum FirebaseChatExceptionCode { chatAlreadyExists }

class FirebaseChatException
    extends CustomFirebaseException<FirebaseChatExceptionCode> {
  const FirebaseChatException({required super.code});
}

enum FirebaseNetworkExceptionCode { requestFailed, tooManyRequests }

class FirebaseNetworkException
    extends CustomFirebaseException<FirebaseNetworkExceptionCode> {
  const FirebaseNetworkException({required super.code});
}

class FirebaseUnknownException extends CustomFirebaseException {
  const FirebaseUnknownException({required super.message}) : super(code: null);
}
