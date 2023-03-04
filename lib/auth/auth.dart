abstract class Auth {
  Future<String?> signIn({
    required String email,
    required String password,
  });
}
