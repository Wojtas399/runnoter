import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../mapper/firebase_exception_mapper.dart';

class FirebaseAuthService {
  Stream<String?> get loggedUserId$ {
    return firebase.FirebaseAuth.instance.authStateChanges().map(
          (firebase.User? user) => user?.uid,
        );
  }

  Stream<String?> get loggedUserEmail$ {
    return firebase.FirebaseAuth.instance.authStateChanges().map(
          (firebase.User? user) => user?.email,
        );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await firebase.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase.FirebaseAuthException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    }
  }

  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await firebase.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        return null;
      }
      return credential.user!.uid;
    } on firebase.FirebaseAuthException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    }
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await firebase.FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
    } on firebase.FirebaseAuthException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    }
  }

  Future<void> signOut() async {
    await firebase.FirebaseAuth.instance.signOut();
  }

  Future<void> updateEmail({
    required String newEmail,
    required String password,
  }) async {
    try {
      await _reauthenticate(password);
      await firebase.FirebaseAuth.instance.currentUser?.updateEmail(newEmail);
    } on firebase.FirebaseAuthException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _reauthenticate(currentPassword);
      await firebase.FirebaseAuth.instance.currentUser
          ?.updatePassword(newPassword);
    } on firebase.FirebaseAuthException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    }
  }

  Future<void> deleteAccount({
    required String password,
  }) async {
    try {
      await _reauthenticate(password);
      await firebase.FirebaseAuth.instance.currentUser?.delete();
    } on firebase.FirebaseAuthException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    }
  }

  Future<bool> isPasswordCorrect({
    required String password,
  }) async {
    try {
      await _reauthenticate(password);
      return true;
    } on firebase.FirebaseAuthException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    }
  }

  Future<void> _reauthenticate(String password) async {
    final String? email = await loggedUserEmail$.first;
    if (email == null) {
      return;
    }
    final firebase.AuthCredential credential =
        firebase.EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await firebase.FirebaseAuth.instance.currentUser
        ?.reauthenticateWithCredential(credential);
  }
}
