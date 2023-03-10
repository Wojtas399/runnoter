abstract class Auth {
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
}
