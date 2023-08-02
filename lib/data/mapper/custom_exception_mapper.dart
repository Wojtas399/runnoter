import 'package:firebase/firebase.dart';

import '../../domain/additional_model/custom_exception.dart';

CustomException mapExceptionFromFirebase(
  FirebaseException firebaseException,
) =>
    switch (firebaseException) {
      FirebaseAuthException() => AuthException(
          code: _mapAuthExceptionCodeFromFirebase(firebaseException.code),
        ),
      FirebaseNetworkException() => NetworkException(
          code: _mapNetworkExceptionCodeFromFirebase(firebaseException.code),
        ),
      FirebaseUnknownException() => UnknownException(
          message: firebaseException.message,
        ),
    };

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
      FirebaseAuthExceptionCode.userMismatch => AuthExceptionCode.userMismatch,
      FirebaseAuthExceptionCode.socialAuthenticationCancelled =>
        AuthExceptionCode.socialAuthenticationCancelled,
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
