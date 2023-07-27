import '../entity/auth_provider.dart';

abstract class AuthService {
  Stream<String?> get loggedUserId$;

  Stream<String?> get loggedUserEmail$;

  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<void> signInWithGoogle();

  Future<String?> signUp({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  Future<void> signOut();

  Future<void> updateEmail({
    required String newEmail,
    required AuthProvider authProvider,
  });

  Future<void> updatePassword({
    required String newPassword,
    required AuthProvider authProvider,
  });

  Future<bool> isPasswordCorrect({
    required String password,
  });

  Future<void> deleteAccount({
    required AuthProvider authProvider,
  });
}
