import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'social_auth_service.dart';

class FacebookAuthService implements SocialAuthService {
  @override
  Future<void> signIn() async {
    if (kIsWeb) {
      final facebookAuthProvider = _createWebProvider();
      await FirebaseAuth.instance.signInWithPopup(facebookAuthProvider);
    } else {
      final OAuthCredential? credential = await _authenticateMobile();
      if (credential != null) {
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    }
  }

  @override
  Future<void> reauthenticate() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (kIsWeb) {
      final facebookProvider = _createWebProvider();
      await user?.reauthenticateWithPopup(facebookProvider);
    } else {
      final OAuthCredential? credential = await _authenticateMobile();
      if (credential != null) {
        await user?.reauthenticateWithCredential(credential);
      }
    }
  }

  Future<OAuthCredential?> _authenticateMobile() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    if (loginResult.status == LoginStatus.cancelled) {
      throw FirebaseAuthException(code: 'web-context-cancelled');
    }
    return loginResult.accessToken != null
        ? FacebookAuthProvider.credential(loginResult.accessToken!.token)
        : null;
  }

  FacebookAuthProvider _createWebProvider() {
    final facebookProvider = FacebookAuthProvider();
    facebookProvider.addScope('email');
    facebookProvider.setCustomParameters({'display': 'popup'});
    return facebookProvider;
  }
}
