import 'package:firebase_auth/firebase_auth.dart';

import '../mapper/firebase_exception_mapper.dart';
import '../model/auth_provider.dart';
import '../social_auth/facebook_auth_service.dart';
import '../social_auth/google_auth_service.dart';
import '../social_auth/social_auth_service.dart';

class FirebaseAuthService {
  final SocialAuthService _googleAuthService = GoogleAuthService();
  final SocialAuthService _facebookAuthService = FacebookAuthService();

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
      await _googleAuthService.signIn();
    } on FirebaseAuthException catch (exception) {
      String code = exception.code;
      if (_hasPopupBeenCancelled(exception)) code = 'web-context-cancelled';
      throw mapFirebaseExceptionFromCodeStr(code);
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      await _facebookAuthService.signIn();
    } on FirebaseAuthException catch (exception) {
      String code = exception.code;
      if (_hasPopupBeenCancelled(exception)) code = 'web-context-cancelled';
      throw mapFirebaseExceptionFromCodeStr(code);
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
        FirebaseAuthProviderPassword() =>
          _reauthenticateUserWithPassword(user, authProvider.password),
        FirebaseAuthProviderGoogle() => _googleAuthService.reauthenticate(),
        FirebaseAuthProviderFacebook() => _facebookAuthService.reauthenticate(),
      };
    } on FirebaseAuthException catch (exception) {
      String code = exception.code;
      if (_hasPopupBeenCancelled(exception)) {
        code = 'web-context-cancelled';
      } else if (exception.message?.contains('user-mismatch') == true) {
        code = 'user-mismatch';
      }
      throw mapFirebaseExceptionFromCodeStr(code);
    }
  }

  bool _hasPopupBeenCancelled(FirebaseAuthException exception) =>
      exception.code == 'web-context-canceled' ||
      exception.message?.contains('popup-closed-by-user') == true ||
      exception.message?.contains('cancelled-popup-request') == true ||
      exception.message?.contains('user-cancelled') == true;

  Future<void> _reauthenticateUserWithPassword(
    User user,
    String password,
  ) async {
    await user.reauthenticateWithCredential(
      EmailAuthProvider.credential(email: user.email!, password: password),
    );
  }
}
