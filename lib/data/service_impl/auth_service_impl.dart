import 'package:firebase/firebase.dart';
import 'package:runnoter/data/mapper/auth_exception_code_mapper.dart';
import 'package:runnoter/domain/model/auth_exception.dart';
import 'package:runnoter/domain/service/auth_service.dart';

class AuthServiceImpl implements AuthService {
  final FirebaseAuthService _firebaseAuthService;
  final FirebaseUserService _firebaseUserService;
  final _authExceptionCodeMapper = AuthExceptionCodeMapper();

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
