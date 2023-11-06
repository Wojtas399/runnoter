import 'package:firebase_auth/firebase_auth.dart';

import 'social_auth_service.dart';

class AppleAuthService implements SocialAuthService {
  @override
  Future<String?> signIn() async {
    final AppleAuthProvider appleProvider = AppleAuthProvider();
    final UserCredential credential =
        await FirebaseAuth.instance.signInWithProvider(appleProvider);
    return credential.user?.uid;
  }

  @override
  Future<String?> reauthenticate() {
    // TODO: implement reauthenticate
    throw UnimplementedError();
  }
}
