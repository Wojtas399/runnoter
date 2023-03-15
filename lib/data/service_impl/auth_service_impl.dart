import 'package:firebase/firebase.dart';
import 'package:firebase/model/firebase_auth_exception_code.dart';

import '../../domain/model/auth_exception.dart';
import '../../domain/service/auth_service.dart';
import '../mapper/auth_exception_mapper.dart';

class AuthServiceImpl implements AuthService {
  final FirebaseAuthService _firebaseAuthService;
  final FirebaseUserService _firebaseUserService;

  AuthServiceImpl({
    required FirebaseAuthService firebaseAuthService,
    required FirebaseUserService firebaseUserService,
  })  : _firebaseAuthService = firebaseAuthService,
        _firebaseUserService = firebaseUserService;

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
    } on FirebaseAuthExceptionCode catch (exception) {
      final AuthException? authException =
          mapFromFirebaseAuthExceptionCodeToAuthException(exception);
      if (authException != null) {
        throw authException;
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> signUp({
    required String name,
    required String surname,
    required String email,
    required String password,
  }) async {
    try {
      final String? userId = await _firebaseAuthService.signUp(
        name: name,
        surname: surname,
        email: email,
        password: password,
      );
      if (userId != null) {
        await _firebaseUserService.addUserPersonalData(
          userId: userId,
          name: name,
          surname: surname,
        );
      }
    } on FirebaseAuthExceptionCode catch (exception) {
      final AuthException? authException =
          mapFromFirebaseAuthExceptionCodeToAuthException(exception);
      if (authException != null) {
        throw authException;
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _firebaseAuthService.sendPasswordResetEmail(email: email);
    } on FirebaseAuthExceptionCode catch (exception) {
      final AuthException? authException =
          mapFromFirebaseAuthExceptionCodeToAuthException(exception);
      if (authException != null) {
        throw authException;
      } else {
        rethrow;
      }
    }
  }
}
