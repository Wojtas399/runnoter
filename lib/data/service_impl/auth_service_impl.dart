import 'package:firebase/firebase.dart' as firebase;

import '../../dependency_injection.dart';
import '../../domain/entity/auth_provider.dart';
import '../../domain/service/auth_service.dart';
import '../mapper/auth_provider_mapper.dart';
import '../mapper/custom_exception_mapper.dart';
import '../mapper/reauthentication_status_mapper.dart';

class AuthServiceImpl implements AuthService {
  final firebase.FirebaseAuthService _firebaseAuthService;

  AuthServiceImpl()
      : _firebaseAuthService = getIt<firebase.FirebaseAuthService>();

  @override
  Stream<String?> get loggedUserId$ => _firebaseAuthService.loggedUserId$;

  @override
  Stream<String?> get loggedUserEmail$ => _firebaseAuthService.loggedUserEmail$;

  @override
  Stream<bool?> get hasLoggedUserVerifiedEmail$ =>
      _firebaseAuthService.hasLoggedUserVerifiedEmail$;

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuthService.signIn(email: email, password: password);
    } on firebase.FirebaseException catch (exception) {
      throw mapExceptionFromFirebase(exception);
    }
  }

  @override
  Future<String?> signInWithGoogle() async {
    try {
      return await _firebaseAuthService.signInWithGoogle();
    } on firebase.FirebaseException catch (exception) {
      throw mapExceptionFromFirebase(exception);
    }
  }

  @override
  Future<String?> signInWithFacebook() async {
    try {
      return await _firebaseAuthService.signInWithFacebook();
    } on firebase.FirebaseException catch (exception) {
      throw mapExceptionFromFirebase(exception);
    }
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
    } on firebase.FirebaseException catch (exception) {
      throw mapExceptionFromFirebase(exception);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuthService.sendEmailVerification();
    } on firebase.FirebaseException catch (exception) {
      throw mapExceptionFromFirebase(exception);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuthService.sendPasswordResetEmail(email: email);
    } on firebase.FirebaseException catch (exception) {
      throw mapExceptionFromFirebase(exception);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
  }

  @override
  Future<void> updateEmail({required String newEmail}) async {
    try {
      await _firebaseAuthService.updateEmail(newEmail: newEmail);
    } on firebase.FirebaseException catch (exception) {
      throw mapExceptionFromFirebase(exception);
    }
  }

  @override
  Future<void> updatePassword({required String newPassword}) async {
    await _firebaseAuthService.updatePassword(newPassword: newPassword);
  }

  @override
  Future<void> deleteAccount() async {
    await _firebaseAuthService.deleteAccount();
  }

  @override
  Future<ReauthenticationStatus> reauthenticate({
    required AuthProvider authProvider,
  }) async {
    try {
      final firebaseReauthenticationStatus = await _firebaseAuthService
          .reauthenticate(authProvider: mapAuthProviderToDb(authProvider));
      return mapReauthenticationStatusFromFirebase(
        firebaseReauthenticationStatus,
      );
    } on firebase.FirebaseException catch (exception) {
      throw mapExceptionFromFirebase(exception);
    }
  }

  @override
  Future<void> reloadLoggedUser() async {
    await _firebaseAuthService.reloadLoggedUser();
  }
}
