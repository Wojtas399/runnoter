import 'package:firebase/firebase.dart' as firebase;
import 'package:runnoter/data/mapper/auth_exception_code_mapper.dart';
import 'package:runnoter/domain/interface/auth.dart';
import 'package:runnoter/domain/model/auth_exception.dart';

class AuthImpl implements Auth {
  final AuthExceptionCodeMapper _authExceptionCodeMapper =
      AuthExceptionCodeMapper();

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await firebase.signIn(
        email: email,
        password: password,
      );
    } on firebase.FirebaseAuthException catch (exception) {
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

  @override
  Future<void> signUp({
    required String name,
    required String surname,
    required String email,
    required String password,
  }) async {
    try {
      final String? userId = await firebase.signUp(
        name: name,
        surname: surname,
        email: email,
        password: password,
      );
      if (userId == null) {
        return;
      }
    } on firebase.FirebaseAuthException catch (exception) {
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
