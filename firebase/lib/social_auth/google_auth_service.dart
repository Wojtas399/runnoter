import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'social_auth_service.dart';

class GoogleAuthService implements SocialAuthService {
  @override
  Future<void> signIn() async {
    if (kIsWeb) {
      await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
    } else {
      final GoogleSignInAccount? gAccount = await GoogleSignIn().signIn();
      if (gAccount == null) return;
      final GoogleSignInAuthentication gAuth = await gAccount.authentication;
      final gCredential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(gCredential);
    }
  }

  @override
  Future<void> reauthenticate() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (kIsWeb) {
      await user?.reauthenticateWithPopup(GoogleAuthProvider());
    } else {
      await user?.reauthenticateWithProvider(GoogleAuthProvider());
    }
  }
}