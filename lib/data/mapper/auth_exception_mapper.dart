import 'package:firebase/firebase.dart';

import '../../domain/additional_model/auth_exception.dart';

AuthException? mapFromFirebaseAuthException(
  FirebaseAuthExceptionCode firebaseAuthExceptionCode,
) =>
    switch (firebaseAuthExceptionCode) {
      FirebaseAuthExceptionCode.invalidEmail => AuthException.invalidEmail,
      FirebaseAuthExceptionCode.wrongPassword => AuthException.wrongPassword,
      FirebaseAuthExceptionCode.userNotFound => AuthException.userNotFound,
      FirebaseAuthExceptionCode.emailAlreadyInUse =>
        AuthException.emailAlreadyInUse,
      FirebaseAuthExceptionCode.networkRequestFailed =>
        AuthException.networkRequestFailed,
      FirebaseAuthExceptionCode.unknown => null,
    };
