import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/model/custom_exception.dart';
import 'package:runnoter/data/service/auth/auth_service.dart';
import 'package:runnoter/data/service/auth/auth_service_impl.dart';

import '../../mock/firebase/mock_firebase_auth_service.dart';

class FakeUserDto extends Fake implements firebase.UserDto {}

void main() {
  final firebaseAuthService = MockFirebaseAuthService();
  late AuthService service;

  setUpAll(() {
    registerFallbackValue(FakeUserDto());
  });

  setUpAll(() {
    GetIt.I.registerFactory<firebase.FirebaseAuthService>(
      () => firebaseAuthService,
    );
  });

  setUp(() {
    service = AuthServiceImpl();
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
    'has logged user verified email, '
    'should call and return result of firebase has logged user verified email getter',
    () async {
      firebaseAuthService.mockHasLoggedUserVerifiedEmail(expected: true);

      final Stream<bool?> hasLoggedUserVerifiedEmail$ =
          service.hasLoggedUserVerifiedEmail$;

      expect(await hasLoggedUserVerifiedEmail$.first, true);
    },
  );

  test(
    'sign in, '
    "should call firebase service's method to sign in user",
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      firebaseAuthService.mockSignIn();

      await service.signIn(email: email, password: password);

      verify(
        () => firebaseAuthService.signIn(email: email, password: password),
      ).called(1);
    },
  );

  test(
    'sign in, '
    'firebase auth exception with invalidEmail code, '
    'should throw domain auth exception with invalidEmail code',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.invalidEmail,
      );
      firebaseAuthService.mockSignIn(
        throwable: const firebase.FirebaseAuthException(
          code: firebase.FirebaseAuthExceptionCode.invalidEmail,
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
        () => firebaseAuthService.signIn(email: email, password: password),
      ).called(1);
    },
  );

  test(
    'sign in, '
    'firebase auth exception with userNotFound code, '
    'should throw domain auth exception with userNotFound code',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.userNotFound,
      );
      firebaseAuthService.mockSignIn(
        throwable: const firebase.FirebaseAuthException(
          code: firebase.FirebaseAuthExceptionCode.userNotFound,
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
        () => firebaseAuthService.signIn(email: email, password: password),
      ).called(1);
    },
  );

  test(
    'sign in, '
    'firebase auth exception with wrongPassword code, '
    'should throw domain auth exception with wrongPassword code',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.wrongPassword,
      );
      firebaseAuthService.mockSignIn(
        throwable: const firebase.FirebaseAuthException(
          code: firebase.FirebaseAuthExceptionCode.wrongPassword,
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
        () => firebaseAuthService.signIn(email: email, password: password),
      ).called(1);
    },
  );

  test(
    'sign in with google, '
    'should call firebase method to sign in with google',
    () async {
      firebaseAuthService.mockSignInWithGoogle(userId: 'u1');

      final String? loggedUserId = await service.signInWithGoogle();

      expect(loggedUserId, 'u1');
      verify(firebaseAuthService.signInWithGoogle).called(1);
    },
  );

  test(
    'sign in with facebook, '
    'should call firebase method to sign in with facebook',
    () async {
      firebaseAuthService.mockSignInWithFacebook(userId: 'u1');

      final String? loggedUserId = await service.signInWithFacebook();

      expect(loggedUserId, 'u1');
      verify(firebaseAuthService.signInWithFacebook).called(1);
    },
  );

  test(
    'sign in with apple, '
    'should call firebase method to sign in with apple',
    () async {
      firebaseAuthService.mockSignInWithApple(userId: 'u1');

      final String? loggedUserId = await service.signInWithApple();

      expect(loggedUserId, 'u1');
      verify(firebaseAuthService.signInWithApple).called(1);
    },
  );

  test(
    'sign up, '
    "should call firebase service's method to sign up user and should return user id",
    () async {
      const String expectedUserId = 'u1';
      const String email = 'email@example.com';
      const String password = 'password123';
      firebaseAuthService.mockSignUp(userId: expectedUserId);

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
    'firebase auth exception with emailAlreadyInUse code, '
    'should throw domain auth exception with emailAlreadyInUse code',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.emailAlreadyInUse,
      );
      firebaseAuthService.mockSignUp(
        throwable: const firebase.FirebaseAuthException(
          code: firebase.FirebaseAuthExceptionCode.emailAlreadyInUse,
        ),
      );

      Object? exception;
      try {
        await service.signUp(email: email, password: password);
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.signUp(email: email, password: password),
      ).called(1);
    },
  );

  test(
    'send email verification, '
    "should call firebase service's method to send email verification",
    () async {
      firebaseAuthService.mockSendEmailVerification();

      await service.sendEmailVerification();

      verify(firebaseAuthService.sendEmailVerification).called(1);
    },
  );

  test(
    'send email verification, '
    'firebase network exception with tooManyRequests code, '
    'should throw domain auth exception with tooManyRequests code',
    () async {
      const NetworkException expectedException = NetworkException(
        code: NetworkExceptionCode.tooManyRequests,
      );
      firebaseAuthService.mockSendEmailVerification(
        throwable: const firebase.FirebaseNetworkException(
          code: firebase.FirebaseNetworkExceptionCode.tooManyRequests,
        ),
      );

      Object? exception;
      try {
        await service.sendEmailVerification();
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(firebaseAuthService.sendEmailVerification).called(1);
    },
  );

  test(
    'send password reset email, '
    "should call firebase service's method to send password reset email",
    () async {
      const String email = 'email@example.com';
      firebaseAuthService.mockSendPasswordResetEmail();

      await service.sendPasswordResetEmail(email: email);

      verify(
        () => firebaseAuthService.sendPasswordResetEmail(email: email),
      ).called(1);
    },
  );

  test(
    'send password reset email, '
    'firebase auth exception with invalidEmail code, '
    'should throw domain auth exception with invalidEmail code',
    () async {
      const String email = 'email@example.com';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.invalidEmail,
      );
      firebaseAuthService.mockSendPasswordResetEmail(
        throwable: const firebase.FirebaseAuthException(
          code: firebase.FirebaseAuthExceptionCode.invalidEmail,
        ),
      );

      Object? exception;
      try {
        await service.sendPasswordResetEmail(email: email);
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.sendPasswordResetEmail(email: email),
      ).called(1);
    },
  );

  test(
    'send password reset email, '
    'firebase auth exception with userNotFound code, '
    'should throw domain auth exception with userNotFound code',
    () async {
      const String email = 'email@example.com';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.userNotFound,
      );
      firebaseAuthService.mockSendPasswordResetEmail(
        throwable: const firebase.FirebaseAuthException(
          code: firebase.FirebaseAuthExceptionCode.userNotFound,
        ),
      );

      Object? exception;
      try {
        await service.sendPasswordResetEmail(email: email);
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.sendPasswordResetEmail(email: email),
      ).called(1);
    },
  );

  test(
    'sign out, '
    "should call firebase service's method to sign out",
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
    "should call firebase service's method to update email",
    () async {
      const String newEmail = 'email@example.com';
      firebaseAuthService.mockUpdateEmail();

      await service.updateEmail(newEmail: newEmail);

      verify(
        () => firebaseAuthService.updateEmail(newEmail: newEmail),
      ).called(1);
    },
  );

  test(
    'update email, '
    'firebase auth exception with emailAlreadyInUse code, '
    'should throw domain auth exception with emailAlreadyInUse code',
    () async {
      const String newEmail = 'email@example.com';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.emailAlreadyInUse,
      );
      firebaseAuthService.mockUpdateEmail(
        throwable: const firebase.FirebaseAuthException(
          code: firebase.FirebaseAuthExceptionCode.emailAlreadyInUse,
        ),
      );

      Object? exception;
      try {
        await service.updateEmail(newEmail: newEmail);
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.updateEmail(newEmail: newEmail),
      ).called(1);
    },
  );

  test(
    'update password, '
    "should call firebase service's method to update password",
    () async {
      const String newPassword = 'password1';
      firebaseAuthService.mockUpdatePassword();

      await service.updatePassword(newPassword: newPassword);

      verify(
        () => firebaseAuthService.updatePassword(newPassword: newPassword),
      ).called(1);
    },
  );

  test(
    'update password, '
    'firebase network exception with requestFailed code, '
    'should throw domain network exception with requestFailed code',
    () async {
      const String newPassword = 'password1';
      const NetworkException expectedException = NetworkException(
        code: NetworkExceptionCode.requestFailed,
      );
      firebaseAuthService.mockUpdatePassword(
        throwable: const firebase.FirebaseNetworkException(
          code: firebase.FirebaseNetworkExceptionCode.requestFailed,
        ),
      );

      Object? exception;
      try {
        await service.updatePassword(newPassword: newPassword);
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.updatePassword(newPassword: newPassword),
      ).called(1);
    },
  );

  test(
    'delete account, '
    "should call firebase service's method to delete currently logged user",
    () async {
      firebaseAuthService.mockDeleteAccount();

      await service.deleteAccount();

      verify(() => firebaseAuthService.deleteAccount()).called(1);
    },
  );

  test(
    'delete account, '
    'firebase network exception with requestFailed code, '
    'should throw domain network exception with requestFailed code',
    () async {
      const NetworkException expectedException = NetworkException(
        code: NetworkExceptionCode.requestFailed,
      );
      firebaseAuthService.mockDeleteAccount(
        throwable: const firebase.FirebaseNetworkException(
          code: firebase.FirebaseNetworkExceptionCode.requestFailed,
        ),
      );

      Object? exception;
      try {
        await service.deleteAccount();
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(() => firebaseAuthService.deleteAccount()).called(1);
    },
  );

  test(
    'reauthenticate, '
    "should call firebase service's method to reauthenticate user",
    () async {
      firebaseAuthService.mockReauthenticate(
        reauthenticationStatus: firebase.ReauthenticationStatus.confirmed,
      );

      final reauthenticationStatus = await service.reauthenticate(
        authProvider: const AuthProviderGoogle(),
      );

      expect(reauthenticationStatus, ReauthenticationStatus.confirmed);
      verify(
        () => firebaseAuthService.reauthenticate(
          authProvider: const firebase.FirebaseAuthProviderGoogle(),
        ),
      ).called(1);
    },
  );

  test(
    'reauthenticate, '
    'firebase exception with wrongPassword code, '
    'should throw domain auth exception with wrongPassword code',
    () async {
      const String password = 'passwd';
      const AuthException expectedException = AuthException(
        code: AuthExceptionCode.wrongPassword,
      );
      firebaseAuthService.mockReauthenticate(
        throwable: const firebase.FirebaseAuthException(
          code: firebase.FirebaseAuthExceptionCode.wrongPassword,
        ),
      );

      Object? exception;
      try {
        await service.reauthenticate(
          authProvider: const AuthProviderPassword(password: password),
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.reauthenticate(
          authProvider: const firebase.FirebaseAuthProviderPassword(
            password: password,
          ),
        ),
      ).called(1);
    },
  );

  test(
    'reload logged user, '
    "should call firebase auth service's method to reload logged user state",
    () async {
      firebaseAuthService.mockReloadLoggedUser();

      await service.reloadLoggedUser();

      verify(firebaseAuthService.reloadLoggedUser).called(1);
    },
  );

  test(
    'reload logged user, '
    'firebase network exception with requestFailed code, '
    'should throw domain network exception with requestFailed code',
    () async {
      const NetworkException expectedException = NetworkException(
        code: NetworkExceptionCode.requestFailed,
      );
      firebaseAuthService.mockReloadLoggedUser(
        throwable: const firebase.FirebaseNetworkException(
          code: firebase.FirebaseNetworkExceptionCode.requestFailed,
        ),
      );

      Object? exception;
      try {
        await service.reloadLoggedUser();
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(firebaseAuthService.reloadLoggedUser).called(1);
    },
  );
}
