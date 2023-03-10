part of firebase;

class FirebaseAuthService {
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<String?> signUp({
    required String name,
    required String surname,
    required String email,
    required String password,
  }) async {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user == null) {
      return null;
    }
    return credential.user!.uid;
  }
}
