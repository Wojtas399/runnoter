import 'package:firebase_auth/firebase_auth.dart';

import '../auth/auth.dart';
import '../mapper/auth_exception_code_mapper.dart';
import '../model/auth_exception.dart';

class FireAuthService implements Auth {
  final AuthExceptionCodeMapper _authExceptionCodeMapper =
      AuthExceptionCodeMapper();

  @override
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        return null;
      }
      return credential.user!.uid;
    } on FirebaseAuthException catch (exception) {
      final AuthExceptionCode? code =
          _authExceptionCodeMapper.mapFromFirebaseCodeToDomainCode(
        firebaseAuthExceptionCode: exception.code,
      );
      if (code != null) {
        throw AuthException(code: code);
      } else {
        rethrow;
      }
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
      if (credential.user == null) {
        return null;
      }
      return credential.user!.uid;
    } on FirebaseAuthException catch (exception) {
      final AuthExceptionCode? code =
          _authExceptionCodeMapper.mapFromFirebaseCodeToDomainCode(
        firebaseAuthExceptionCode: exception.code,
      );
      if (code != null) {
        throw AuthException(code: code);
      } else {
        rethrow;
      }
    }
  }
}
