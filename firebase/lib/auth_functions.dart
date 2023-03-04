part of firebase_lib;

Future<Credential?> signInWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user == null) {
      return null;
    }
    return Credential(
      userId: credential.user!.uid,
      email: email,
    );
  } on FirebaseAuthException catch (exception) {
    if (exception.code == 'user-not-found') {
      throw FireAuthException(
        code: FireAuthExceptionCode.userNotFound,
      );
    } else if (exception.code == 'wrong password') {
      throw FireAuthException(
        code: FireAuthExceptionCode.wrongPassword,
      );
    } else {
      rethrow;
    }
  }
}

Future<Credential?> signUpWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user == null) {
      return null;
    }
    return Credential(
      userId: credential.user!.uid,
      email: email,
    );
  } on FirebaseAuthException catch (exception) {
    if (exception.code == 'email-already-taken') {
      throw FireAuthException(
        code: FireAuthExceptionCode.userNotFound,
      );
    } else {
      rethrow;
    }
  }
}
