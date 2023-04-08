part of firebase;

class FirebaseAuthService {
  Stream<String?> get loggedUserId$ {
    return FirebaseAuth.instance.authStateChanges().map(
          (User? user) => user?.uid,
        );
  }

  Stream<String?> get loggedUserEmail$ {
    return FirebaseAuth.instance.authStateChanges().map(
          (User? user) => user?.email,
        );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (exception) {
      final FirebaseAuthExceptionCode code = mapFirebaseAuthExceptionCodeToEnum(
        exception.code,
      );
      if (code != FirebaseAuthExceptionCode.unknown) {
        throw code;
      } else {
        rethrow;
      }
    }
  }

  Future<String?> signUp({
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
      return credential.user!.uid;
    } on FirebaseAuthException catch (exception) {
      final FirebaseAuthExceptionCode code = mapFirebaseAuthExceptionCodeToEnum(
        exception.code,
      );
      if (code != FirebaseAuthExceptionCode.unknown) {
        throw code;
      } else {
        rethrow;
      }
    }
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (exception) {
      final FirebaseAuthExceptionCode code = mapFirebaseAuthExceptionCodeToEnum(
        exception.code,
      );
      if (code != FirebaseAuthExceptionCode.unknown) {
        throw code;
      } else {
        rethrow;
      }
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> updateEmail({
    required String newEmail,
    required String password,
  }) async {
    try {
      await _reauthenticate(password);
      await FirebaseAuth.instance.currentUser?.updateEmail(newEmail);
    } on FirebaseAuthException catch (exception) {
      final FirebaseAuthExceptionCode code = mapFirebaseAuthExceptionCodeToEnum(
        exception.code,
      );
      if (code != FirebaseAuthExceptionCode.unknown) {
        throw code;
      } else {
        rethrow;
      }
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _reauthenticate(currentPassword);
      await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (exception) {
      final FirebaseAuthExceptionCode code = mapFirebaseAuthExceptionCodeToEnum(
        exception.code,
      );
      if (code != FirebaseAuthExceptionCode.unknown) {
        throw code;
      } else {
        rethrow;
      }
    }
  }

  Future<void> deleteAccount({
    required String password,
  }) async {
    try {
      await _reauthenticate(password);
      await FirebaseAuth.instance.currentUser?.delete();
    } on FirebaseAuthException catch (exception) {
      final FirebaseAuthExceptionCode code = mapFirebaseAuthExceptionCodeToEnum(
        exception.code,
      );
      if (code != FirebaseAuthExceptionCode.unknown) {
        throw code;
      } else {
        rethrow;
      }
    }
  }

  Future<bool> isPasswordCorrect({
    required String password,
  }) async {
    try {
      await _reauthenticate(password);
      return true;
    } on FirebaseAuthException catch (exception) {
      final FirebaseAuthExceptionCode code = mapFirebaseAuthExceptionCodeToEnum(
        exception.code,
      );
      if (code == FirebaseAuthExceptionCode.wrongPassword) {
        return false;
      } else {
        rethrow;
      }
    }
  }

  Future<void> _reauthenticate(String password) async {
    final String? email = await loggedUserEmail$.first;
    if (email == null) {
      return;
    }
    final AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(
      credential,
    );
  }
}
