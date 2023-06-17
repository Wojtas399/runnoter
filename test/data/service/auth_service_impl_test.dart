import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/service_impl/auth_service_impl.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';

import '../../mock/firebase/mock_firebase_auth_service.dart';

class FakeUserDto extends Fake implements UserDto {}

void main() {
  final firebaseAuthService = MockFirebaseAuthService();
  late AuthServiceImpl service;

  setUpAll(() {
    registerFallbackValue(FakeUserDto());
  });

  setUp(() {
    service = AuthServiceImpl(
      firebaseAuthService: firebaseAuthService,
    );
  });

  tearDown(() {
    reset(firebaseAuthService);
  });

  test(
    'get logged user id, '
    'should call and return result of firebase logged user id getter',
    () async {
      const String expectedLoggedUserId = 'u1';
      firebaseAuthService.mockGetLoggedUserId(
        userId: expectedLoggedUserId,
      );

      final Stream<String?> loggedUserId$ = service.loggedUserId$;

      expect(await loggedUserId$.first, expectedLoggedUserId);
    },
  );

  test(
    'get logged user email, '
    'should call and return result of firebase logged user email getter',
    () async {
      const String expectedLoggedUserEmail = 'email@example.com';
      firebaseAuthService.mockGetLoggedUserEmail(
        userEmail: expectedLoggedUserEmail,
      );

      final Stream<String?> loggedUserEmail$ = service.loggedUserEmail$;

      expect(await loggedUserEmail$.first, expectedLoggedUserEmail);
    },
  );

  test(
    'sign in, '
    'should call firebase method to sign in user',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      firebaseAuthService.mockSignIn();

      await service.signIn(email: email, password: password);

      verify(
        () => firebaseAuthService.signIn(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'sign in, '
    'firebase auth exception with invalid email code, '
    'should throw auth exception with invalid email code',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.invalidEmail,
      );
      firebaseAuthService.mockSignIn(
        throwable: const FirebaseAuthException(
          code: FirebaseAuthExceptionCode.invalidEmail,
        ),
      );

      Object? exception;
      try {
        await service.signIn(email: email, password: password);
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.signIn(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'sign in, '
    'firebase auth exception with user not found code, '
    'should throw auth exception with user not found code',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.userNotFound,
      );
      firebaseAuthService.mockSignIn(
        throwable: const FirebaseAuthException(
          code: FirebaseAuthExceptionCode.userNotFound,
        ),
      );

      Object? exception;
      try {
        await service.signIn(email: email, password: password);
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.signIn(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'sign in, '
    'firebase auth exception with wrong password code, '
    'should throw auth exception with wrong password code',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.wrongPassword,
      );
      firebaseAuthService.mockSignIn(
        throwable: const FirebaseAuthException(
          code: FirebaseAuthExceptionCode.wrongPassword,
        ),
      );

      Object? exception;
      try {
        await service.signIn(email: email, password: password);
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.signIn(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'sign in, '
    'unknown exception, '
    'should throw unknown exception',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const String unknownExceptionMessage = 'unknown exception message';
      const UnknownException expectedException = UnknownException(
        message: unknownExceptionMessage,
      );
      firebaseAuthService.mockSignIn(
        throwable: const FirebaseUnknownException(
          message: unknownExceptionMessage,
        ),
      );

      Object? exception;
      try {
        await service.signIn(email: email, password: password);
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.signIn(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'sign up, '
    'should call firebase method to sign up user and should return user id',
    () async {
      const String expectedUserId = 'u1';
      const String email = 'email@example.com';
      const String password = 'password123';
      firebaseAuthService.mockSignUp(
        userId: expectedUserId,
      );

      final String? userId = await service.signUp(
        email: email,
        password: password,
      );

      expect(userId, expectedUserId);
      verify(
        () => firebaseAuthService.signUp(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'sign up, '
    'firebase auth exception with email already in use code, '
    'should throw auth exception with email already in use code',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.emailAlreadyInUse,
      );
      firebaseAuthService.mockSignUp(
        throwable: const FirebaseAuthException(
          code: FirebaseAuthExceptionCode.emailAlreadyInUse,
        ),
      );

      Object? exception;
      try {
        await service.signUp(
          email: email,
          password: password,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.signUp(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'sign up, '
    'unknown exception, '
    'should throw unknown exception',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const String unknownExceptionMessage = 'unknown exception message';
      const UnknownException expectedException = UnknownException(
        message: unknownExceptionMessage,
      );
      firebaseAuthService.mockSignUp(
        throwable: const FirebaseUnknownException(
          message: unknownExceptionMessage,
        ),
      );

      Object? exception;
      try {
        await service.signUp(
          email: email,
          password: password,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.signUp(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'send password reset email, '
    'should call firebase method to send password reset email',
    () async {
      const String email = 'email@example.com';
      firebaseAuthService.mockSendPasswordResetEmail();

      await service.sendPasswordResetEmail(
        email: email,
      );

      verify(
        () => firebaseAuthService.sendPasswordResetEmail(
          email: email,
        ),
      ).called(1);
    },
  );

  test(
    'send password reset email, '
    'firebase auth exception with invalid email code, '
    'should throw auth exception with invalid email code',
    () async {
      const String email = 'email@example.com';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.invalidEmail,
      );
      firebaseAuthService.mockSendPasswordResetEmail(
        throwable: const FirebaseAuthException(
          code: FirebaseAuthExceptionCode.invalidEmail,
        ),
      );

      Object? exception;
      try {
        await service.sendPasswordResetEmail(
          email: email,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.sendPasswordResetEmail(
          email: email,
        ),
      ).called(1);
    },
  );

  test(
    'send password reset email, '
    'firebase auth exception with user not found code, '
    'should throw auth exception with user not found code',
    () async {
      const String email = 'email@example.com';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.userNotFound,
      );
      firebaseAuthService.mockSendPasswordResetEmail(
        throwable: const FirebaseAuthException(
          code: FirebaseAuthExceptionCode.userNotFound,
        ),
      );

      Object? exception;
      try {
        await service.sendPasswordResetEmail(
          email: email,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.sendPasswordResetEmail(
          email: email,
        ),
      ).called(1);
    },
  );

  test(
    'send password reset email, '
    'unknown exception, '
    'should throw unknown exception',
    () async {
      const String email = 'email@example.com';
      const String unknownExceptionMessage = 'unknown exception message';
      const UnknownException expectedException = UnknownException(
        message: unknownExceptionMessage,
      );
      firebaseAuthService.mockSendPasswordResetEmail(
        throwable: const FirebaseUnknownException(
          message: unknownExceptionMessage,
        ),
      );

      Object? exception;
      try {
        await service.sendPasswordResetEmail(
          email: email,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.sendPasswordResetEmail(
          email: email,
        ),
      ).called(1);
    },
  );

  test(
    'sign out, '
    'should call firebase method to sign out',
    () async {
      firebaseAuthService.mockSignOut();

      await service.signOut();

      verify(
        () => firebaseAuthService.signOut(),
      ).called(1);
    },
  );

  test(
    'update email, '
    'should call firebase method to update email',
    () async {
      const String newEmail = 'email@example.com';
      const String password = 'password1';
      firebaseAuthService.mockUpdateEmail();

      await service.updateEmail(
        newEmail: newEmail,
        password: password,
      );

      verify(
        () => firebaseAuthService.updateEmail(
          newEmail: newEmail,
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'update email, '
    'firebase auth exception with wrong password code, '
    'should throw auth exception with wrong password code',
    () async {
      const String newEmail = 'email@example.com';
      const String password = 'password1';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.wrongPassword,
      );
      firebaseAuthService.mockUpdateEmail(
        throwable: const FirebaseAuthException(
          code: FirebaseAuthExceptionCode.wrongPassword,
        ),
      );

      Object? exception;
      try {
        await service.updateEmail(
          newEmail: newEmail,
          password: password,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.updateEmail(
          newEmail: newEmail,
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'update email, '
    'firebase auth exception with email already in use code, '
    'should throw auth exception with email already in use code',
    () async {
      const String newEmail = 'email@example.com';
      const String password = 'password1';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.emailAlreadyInUse,
      );
      firebaseAuthService.mockUpdateEmail(
        throwable: const FirebaseAuthException(
          code: FirebaseAuthExceptionCode.emailAlreadyInUse,
        ),
      );

      Object? exception;
      try {
        await service.updateEmail(
          newEmail: newEmail,
          password: password,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.updateEmail(
          newEmail: newEmail,
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'update email, '
    'unknown exception, '
    'should throw unknown exception',
    () async {
      const String newEmail = 'email@example.com';
      const String password = 'password1';
      const String unknownExceptionMessage = 'unknown exception message';
      const UnknownException expectedException = UnknownException(
        message: unknownExceptionMessage,
      );
      firebaseAuthService.mockUpdateEmail(
        throwable: const FirebaseUnknownException(
          message: unknownExceptionMessage,
        ),
      );

      Object? exception;
      try {
        await service.updateEmail(
          newEmail: newEmail,
          password: password,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.updateEmail(
          newEmail: newEmail,
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'update password, '
    'should call firebase method to update password',
    () async {
      const String newPassword = 'password1';
      const String currentPassword = 'password2';
      firebaseAuthService.mockUpdatePassword();

      await service.updatePassword(
        newPassword: newPassword,
        currentPassword: currentPassword,
      );

      verify(
        () => firebaseAuthService.updatePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      ).called(1);
    },
  );

  test(
    'update password, '
    'firebase exception with wrong password code, '
    'should throw auth exception with wrong password code',
    () async {
      const String newPassword = 'password1';
      const String currentPassword = 'password2';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.wrongPassword,
      );
      firebaseAuthService.mockUpdatePassword(
        throwable: const FirebaseAuthException(
            code: FirebaseAuthExceptionCode.wrongPassword),
      );

      Object? exception;
      try {
        await service.updatePassword(
          newPassword: newPassword,
          currentPassword: currentPassword,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.updatePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      ).called(1);
    },
  );

  test(
    'update password, '
    'unknown exception, '
    'should throw unknown exception',
    () async {
      const String newPassword = 'password1';
      const String currentPassword = 'password2';
      const String unknownExceptionMessage = 'unknown exception message';
      const UnknownException expectedException = UnknownException(
        message: unknownExceptionMessage,
      );
      firebaseAuthService.mockUpdatePassword(
        throwable: const FirebaseUnknownException(
          message: unknownExceptionMessage,
        ),
      );

      Object? exception;
      try {
        await service.updatePassword(
          newPassword: newPassword,
          currentPassword: currentPassword,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.updatePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      ).called(1);
    },
  );

  test(
    'is password correct, '
    'should return result of firebase auth service method to check password correctness',
    () async {
      const String password = 'password1';
      const bool expectedResult = true;
      firebaseAuthService.mockIsPasswordCorrect(isCorrect: expectedResult);

      final bool result = await service.isPasswordCorrect(
        password: password,
      );

      expect(result, expectedResult);
      verify(
        () => firebaseAuthService.isPasswordCorrect(
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'delete account, '
    'should call firebase method to delete currently logged user',
    () async {
      const String password = 'password1';
      firebaseAuthService.mockDeleteAccount();

      await service.deleteAccount(
        password: password,
      );

      verify(
        () => firebaseAuthService.deleteAccount(
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'delete account, '
    'firebase exception with wrong password code, '
    'should throw auth exception with wrong password code',
    () async {
      const String password = 'password1';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.wrongPassword,
      );
      firebaseAuthService.mockDeleteAccount(
        throwable: const FirebaseAuthException(
          code: FirebaseAuthExceptionCode.wrongPassword,
        ),
      );

      Object? exception;
      try {
        await service.deleteAccount(
          password: password,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.deleteAccount(
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'delete logged user account, '
    'unknown exception, '
    'should throw unknown exception',
    () async {
      const String password = 'password1';
      const String unknownExceptionMessage = 'unknown exception message';
      const UnknownException expectedException = UnknownException(
        message: unknownExceptionMessage,
      );
      firebaseAuthService.mockDeleteAccount(
        throwable: const FirebaseUnknownException(
          message: unknownExceptionMessage,
        ),
      );

      Object? exception;
      try {
        await service.deleteAccount(
          password: password,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.deleteAccount(
          password: password,
        ),
      ).called(1);
    },
  );
}
