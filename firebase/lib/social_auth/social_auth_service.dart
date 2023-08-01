abstract interface class SocialAuthService {
  Future<void> signIn();

  Future<void> reauthenticate();
}
