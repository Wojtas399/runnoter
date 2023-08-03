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

  Stream<bool?> get hasLoggedUserVerifiedEmail$ => FirebaseAuth.instance
      .userChanges()
      .map((User? user) => user?.emailVerified);

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

  Future<String?> signInWithGoogle() async {
    try {
      return await _googleAuthService.signIn();
    } on FirebaseAuthException catch (exception) {
      if (_hasPopupBeenCancelled(exception)) return null;
      String code = exception.code;
      if (_isInternalError(exception)) {
        code = 'network-request-failed';
      }
      throw mapFirebaseExceptionFromCodeStr(code);
    }
  }

  Future<String?> signInWithFacebook() async {
    try {
      return await _facebookAuthService.signIn();
    } on FirebaseAuthException catch (exception) {
      if (_hasPopupBeenCancelled(exception)) return null;
      String code = exception.code;
      if (_isInternalError(exception)) {
        code = 'network-request-failed';
      }
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

  Future<void> sendEmailVerification() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
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

  Future<ReauthenticationStatus> reauthenticate({
    required FirebaseAuthProvider authProvider,
  }) async {
    try {
      final String? reauthenticatedUserId = await _reauthenticate(authProvider);
      return reauthenticatedUserId != null
          ? ReauthenticationStatus.confirmed
          : ReauthenticationStatus.cancelled;
    } on FirebaseAuthException catch (exception) {
      if (_hasPopupBeenCancelled(exception)) {
        return ReauthenticationStatus.cancelled;
      } else if (_isUserMismatch(exception)) {
        return ReauthenticationStatus.userMismatch;
      }
      String code = exception.code;
      if (_isInternalError(exception)) {
        code = 'network-request-failed';
      }
      throw mapFirebaseExceptionFromCodeStr(code);
    }
  }

  Future<void> reloadLoggedUserState() async {
    await FirebaseAuth.instance.currentUser?.reload();
  }

  bool _hasPopupBeenCancelled(FirebaseAuthException exception) =>
      exception.code == 'web-context-cancelled' ||
      exception.code == 'web-context-canceled' ||
      exception.message?.contains('popup-closed-by-user') == true ||
      exception.message?.contains('cancelled-popup-request') == true ||
      exception.message?.contains('user-cancelled') == true;

  bool _isUserMismatch(FirebaseAuthException exception) =>
      exception.code == 'user-mismatch' ||
      exception.message?.contains('user-mismatch') == true;

  bool _isInternalError(FirebaseAuthException exception) =>
      exception.message?.contains('An internal error') == true ||
      exception.message?.contains('internal-error') == true;

  Future<String?> _reauthenticate(FirebaseAuthProvider authProvider) async =>
      await switch (authProvider) {
        FirebaseAuthProviderPassword() =>
          _reauthenticateWithPassword(authProvider.password),
        FirebaseAuthProviderGoogle() => _googleAuthService.reauthenticate(),
        FirebaseAuthProviderFacebook() => _facebookAuthService.reauthenticate(),
      };

  Future<String?> _reauthenticateWithPassword(String password) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    final UserCredential credential = await user.reauthenticateWithCredential(
      EmailAuthProvider.credential(email: user.email!, password: password),
    );
    return credential.user?.uid;
  }
}

enum ReauthenticationStatus { confirmed, cancelled, userMismatch }
