import 'package:firebase/firebase.dart';

import '../../domain/additional_model/custom_exception.dart';

CustomException mapExceptionFromFirebase(
  CustomFirebaseException firebaseException,
) =>
    (switch (firebaseException) {
      FirebaseAuthException() => AuthException(
          code: _mapAuthExceptionCodeFromFirebase(firebaseException.code),
        ),
      FirebaseDbException() => const UnknownException(message: ''), //TODO
      FirebaseNetworkException() => NetworkException(
          code: _mapNetworkExceptionCodeFromFirebase(firebaseException.code),
        ),
      FirebaseChatException() => ChatException(
          code: _mapChatExceptionCodeFromFirebase(firebaseException.code),
        ),
      FirebaseUnknownException() => UnknownException(
          message: firebaseException.message,
        ),
    }) as CustomException;

AuthExceptionCode _mapAuthExceptionCodeFromFirebase(
  FirebaseAuthExceptionCode firebaseAuthExceptionCode,
) =>
    switch (firebaseAuthExceptionCode) {
      FirebaseAuthExceptionCode.invalidEmail => AuthExceptionCode.invalidEmail,
      FirebaseAuthExceptionCode.emailAlreadyInUse =>
        AuthExceptionCode.emailAlreadyInUse,
      FirebaseAuthExceptionCode.userNotFound => AuthExceptionCode.userNotFound,
      FirebaseAuthExceptionCode.wrongPassword =>
        AuthExceptionCode.wrongPassword,
    };

NetworkExceptionCode _mapNetworkExceptionCodeFromFirebase(
  FirebaseNetworkExceptionCode firebaseNetworkExceptionCode,
) =>
    switch (firebaseNetworkExceptionCode) {
      FirebaseNetworkExceptionCode.requestFailed =>
        NetworkExceptionCode.requestFailed,
      FirebaseNetworkExceptionCode.tooManyRequests =>
        NetworkExceptionCode.tooManyRequests,
    };

ChatExceptionCode _mapChatExceptionCodeFromFirebase(
  FirebaseChatExceptionCode firebaseChatExceptionCode,
) =>
    switch (firebaseChatExceptionCode) {
      FirebaseChatExceptionCode.chatAlreadyExists =>
        ChatExceptionCode.chatAlreadyExists,
    };
