abstract interface class SocialAuthService {
  Future<String?> signIn();

  Future<String?> reauthenticate();
}
