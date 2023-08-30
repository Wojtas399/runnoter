import '../additional_model/auth_provider.dart';

abstract class AuthService {
  Stream<String?> get loggedUserId$;

  Stream<String?> get loggedUserEmail$;

  Stream<bool?> get hasLoggedUserVerifiedEmail$;

  Future<void> signIn({required String email, required String password});

  Future<String?> signInWithGoogle();

  Future<String?> signInWithFacebook();

  Future<String?> signUp({required String email, required String password});

  Future<void> sendEmailVerification();

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut();

  Future<void> updateEmail({required String newEmail});

  Future<void> updatePassword({required String newPassword});

  Future<void> deleteAccount();

  Future<ReauthenticationStatus> reauthenticate({
    required AuthProvider authProvider,
  });

  Future<void> reloadLoggedUser();
}

enum ReauthenticationStatus { confirmed, cancelled, userMismatch }
