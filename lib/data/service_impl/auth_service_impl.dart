import 'package:firebase/firebase.dart';

import '../../dependency_injection.dart';
import '../../domain/entity/auth_provider.dart';
import '../../domain/service/auth_service.dart';
import '../mapper/auth_provider_mapper.dart';
import '../mapper/custom_exception_mapper.dart';

class AuthServiceImpl implements AuthService {
  final FirebaseAuthService _firebaseAuthService;

  AuthServiceImpl() : _firebaseAuthService = getIt<FirebaseAuthService>();

  @override
  Stream<String?> get loggedUserId$ => _firebaseAuthService.loggedUserId$;

  @override
  Stream<String?> get loggedUserEmail$ => _firebaseAuthService.loggedUserEmail$;

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuthService.signIn(
        email: email,
        password: password,
      );
    } on FirebaseException catch (exception) {
      throw mapExceptionFromFirebase(exception);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    await _firebaseAuthService.signInWithGoogle();
  }

  @override
  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuthService.signUp(
        email: email,
        password: password,
      );
    } on FirebaseException catch (exception) {
      throw mapExceptionFromFirebase(exception);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _firebaseAuthService.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (exception) {
      throw mapExceptionFromFirebase(exception);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
  }

  @override
  Future<void> updateEmail({
    required String newEmail,
    required AuthProvider authProvider,
  }) async {
    try {
      await _firebaseAuthService.updateEmail(
        newEmail: newEmail,
        authProvider: mapAuthProviderToDb(authProvider),
      );
    } on FirebaseException catch (exception) {
      throw mapExceptionFromFirebase(exception);
    }
  }

  @override
  Future<void> updatePassword({
    required String newPassword,
    required AuthProvider authProvider,
  }) async {
    try {
      await _firebaseAuthService.updatePassword(
        newPassword: newPassword,
        authProvider: mapAuthProviderToDb(authProvider),
      );
    } on FirebaseException catch (exception) {
      throw mapExceptionFromFirebase(exception);
    }
  }

  @override
  Future<bool> isPasswordCorrect({
    required String password,
  }) async {
    return await _firebaseAuthService.isPasswordCorrect(
      password: password,
    );
  }

  @override
  Future<void> deleteAccount({
    required AuthProvider authProvider,
  }) async {
    try {
      await _firebaseAuthService.deleteAccount(
        authProvider: mapAuthProviderToDb(authProvider),
      );
    } on FirebaseException catch (exception) {
      throw mapExceptionFromFirebase(exception);
    }
  }
}
