import 'package:firebase/firebase.dart';

import '../model/custom_exception.dart';

CustomException mapExceptionFromDb(
  CustomFirebaseException dbException,
) =>
    (switch (dbException) {
      FirebaseAuthException() => AuthException(
          code: _mapAuthExceptionCodeFromFirebase(dbException.code),
        ),
      FirebaseDocumentException() => EntityException(
          code: _mapDocumentExceptionCodeFromDb(dbException.code),
        ),
      FirebaseNetworkException() => NetworkException(
          code: _mapNetworkExceptionCodeFromFirebase(dbException.code),
        ),
      FirebaseUnknownException() => UnknownException(
          message: dbException.message,
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

EntityExceptionCode _mapDocumentExceptionCodeFromDb(
  FirebaseDocumentExceptionCode firebaseDocumentExceptionCode,
) =>
    switch (firebaseDocumentExceptionCode) {
      FirebaseDocumentExceptionCode.documentAlreadyExists =>
        EntityExceptionCode.entityAlreadyExists,
      FirebaseDocumentExceptionCode.documentNotFound =>
        EntityExceptionCode.entityNotFound,
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
