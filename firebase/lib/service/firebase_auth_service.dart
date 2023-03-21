part of firebase;

class FirebaseAuthService {
  Stream<String?> get loggedUserId {
    return FirebaseAuth.instance.authStateChanges().map(
          (User? user) => user?.uid,
        );
  }

  Stream<String?> get loggedUserEmail {
    return FirebaseAuth.instance.authStateChanges().map(
          (User? user) => user?.email,
        );
  }

  bool isUserSignedIn() {
    return FirebaseAuth.instance.currentUser != null;
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
      }
      rethrow;
    }
  }

  Future<String?> signUp({
    required String name,
    required String surname,
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
      }
      rethrow;
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
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
