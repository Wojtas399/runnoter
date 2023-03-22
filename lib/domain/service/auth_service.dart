abstract class AuthService {
  Stream<String?> get loggedUserId$;

  Stream<String?> get loggedUserEmail$;

  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String name,
    required String surname,
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  Future<void> signOut();
}
