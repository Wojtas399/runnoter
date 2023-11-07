import 'package:firebase_auth/firebase_auth.dart';

import 'social_auth_service.dart';

class AppleAuthService implements SocialAuthService {
  @override
  Future<String?> signIn() async {
    final UserCredential credential =
        await FirebaseAuth.instance.signInWithProvider(AppleAuthProvider());
    return credential.user?.uid;
  }

  @override
  Future<String?> reauthenticate() async {
    final UserCredential? credential = await FirebaseAuth.instance.currentUser
        ?.reauthenticateWithProvider(AppleAuthProvider());
    return credential?.user?.uid;
  }
}
