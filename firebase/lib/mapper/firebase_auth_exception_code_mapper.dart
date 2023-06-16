import '../model/firebase_auth_exception_code.dart';

FirebaseAuthExceptionCode mapFirebaseAuthExceptionCodeToEnum(String code) =>
    switch (code) {
      'invalid-email' => FirebaseAuthExceptionCode.invalidEmail,
      'user-not-found' => FirebaseAuthExceptionCode.userNotFound,
      'wrong-password' => FirebaseAuthExceptionCode.wrongPassword,
      'email-already-in-use' => FirebaseAuthExceptionCode.emailAlreadyInUse,
      'network-request-failed' =>
        FirebaseAuthExceptionCode.networkRequestFailed,
      String() => FirebaseAuthExceptionCode.unknown,
    };
