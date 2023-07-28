import '../entity/auth_provider.dart';

abstract class AuthService {
  Stream<String?> get loggedUserId$;

  Stream<String?> get loggedUserEmail$;

  Future<void> signIn({required String email, required String password});

  Future<void> signInWithGoogle();

  Future<String?> signUp({required String email, required String password});

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut();

  Future<void> updateEmail({required String newEmail});

  Future<void> updatePassword({required String newPassword});

  Future<void> deleteAccount();

  Future<void> reauthenticate({required AuthProvider authProvider});
}
