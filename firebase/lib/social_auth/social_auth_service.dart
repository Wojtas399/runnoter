abstract interface class SocialAuthService {
  Future<String?> signIn();

  Future<void> reauthenticate();
}
