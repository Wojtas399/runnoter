import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../mapper/firebase_exception_mapper.dart';
import '../model/auth_provider.dart';

class FirebaseAuthService {
  Stream<String?> get loggedUserId$ =>
      FirebaseAuth.instance.authStateChanges().map((User? user) => user?.uid);

  Stream<String?> get loggedUserEmail$ =>
      FirebaseAuth.instance.userChanges().map((User? user) => user?.email);

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gAccount = await GoogleSignIn().signIn();
      if (gAccount == null) return;
      final GoogleSignInAuthentication gAuth = await gAccount.authentication;
      final gCredential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(gCredential);
    } on FirebaseAuthException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    }
  }

  Future<void> signInWithTwitter() async {
    try {
      TwitterAuthProvider twitterProvider = TwitterAuthProvider();
      if (kIsWeb) {
        await FirebaseAuth.instance.signInWithPopup(twitterProvider);
      } else {
        await FirebaseAuth.instance.signInWithProvider(twitterProvider);
      }
    } on FirebaseAuthException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    }
  }

  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user?.uid;
    } on FirebaseAuthException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    }
  }

  Future<void> signOut() async => await FirebaseAuth.instance.signOut();

  Future<void> updateEmail({required String newEmail}) async {
    try {
      await FirebaseAuth.instance.currentUser?.updateEmail(newEmail);
    } on FirebaseAuthException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    }
  }

  Future<void> updatePassword({required String newPassword}) async {
    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
    } on FirebaseAuthException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    }
  }

  Future<void> reauthenticate({
    required FirebaseAuthProvider authProvider,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await switch (authProvider) {
        FirebaseAuthProviderPassword() => user.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: user.email!,
              password: authProvider.password,
            ),
          ),
        FirebaseAuthProviderGoogle() => kIsWeb
            ? user.reauthenticateWithRedirect(GoogleAuthProvider())
            : user.reauthenticateWithProvider(GoogleAuthProvider()),
        FirebaseAuthProviderTwitter() => kIsWeb
            ? user.reauthenticateWithRedirect(TwitterAuthProvider())
            : user.reauthenticateWithProvider(TwitterAuthProvider()),
      };
    } on FirebaseAuthException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    }
  }
}
