import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'social_auth_service.dart';

class FacebookAuthService implements SocialAuthService {
  @override
  Future<String?> signIn() async {
    UserCredential? credential;
    if (kIsWeb) {
      final facebookAuthProvider = _createWebProvider();
      credential =
          await FirebaseAuth.instance.signInWithPopup(facebookAuthProvider);
    } else {
      final OAuthCredential? oAuthCredential = await _authenticateMobile();
      if (oAuthCredential != null) {
        credential =
            await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
      }
    }
    return credential?.user?.uid;
  }

  @override
  Future<String?> reauthenticate() async {
    final User? user = FirebaseAuth.instance.currentUser;
    UserCredential? credential;
    if (kIsWeb) {
      final facebookProvider = _createWebProvider();
      credential = await user?.reauthenticateWithPopup(facebookProvider);
    } else {
      final OAuthCredential? oAuthCredential = await _authenticateMobile();
      if (oAuthCredential != null) {
        credential = await user?.reauthenticateWithCredential(oAuthCredential);
      }
    }
    return credential?.user?.uid;
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
