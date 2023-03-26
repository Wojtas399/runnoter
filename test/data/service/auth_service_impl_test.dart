import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/service_impl/auth_service_impl.dart';
import 'package:runnoter/domain/model/auth_exception.dart';

import '../../mock/firebase/mock_firebase_auth_service.dart';
import '../../mock/firebase/mock_firebase_user_service.dart';

class FakeUserDto extends Fake implements UserDto {}

void main() {
  final firebaseAuthService = MockFirebaseAuthService();
  final firebaseUserService = MockFirebaseUserService();
  late AuthServiceImpl service;

  setUpAll(() {
    registerFallbackValue(FakeUserDto());
  });

  setUp(() {
    service = AuthServiceImpl(
      firebaseAuthService: firebaseAuthService,
      firebaseUserService: firebaseUserService,
    );
  });

  tearDown(() {
    reset(firebaseAuthService);
    reset(firebaseUserService);
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
    'invalid email firebase exception, '
    'should throw invalid email auth exception',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const AuthException expectedException = AuthException.invalidEmail;
      firebaseAuthService.mockSignIn(
        throwable: FirebaseAuthExceptionCode.invalidEmail,
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
    'user not found firebase exception, '
    'should throw user not found auth exception',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const AuthException expectedException = AuthException.userNotFound;
      firebaseAuthService.mockSignIn(
        throwable: FirebaseAuthExceptionCode.userNotFound,
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
    'wrong password firebase exception, '
    'should throw user not found auth exception',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const AuthException expectedException = AuthException.wrongPassword;
      firebaseAuthService.mockSignIn(
        throwable: FirebaseAuthExceptionCode.wrongPassword,
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
    'should rethrow exception',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const String expectedException = 'Unknown exception...';
      firebaseAuthService.mockSignIn(
        throwable: expectedException,
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
    'should call firebase method to sign up user and to add personal data of user',
    () async {
      const String userId = 'u1';
      const String name = 'Jack';
      const String surname = 'Gadovsky';
      const String email = 'email@example.com';
      const String password = 'password123';
      firebaseAuthService.mockSignUp(
        userId: userId,
      );
      firebaseUserService.mockAddUserPersonalData();

      await service.signUp(
        name: name,
        surname: surname,
        email: email,
        password: password,
      );

      verify(
        () => firebaseAuthService.signUp(
          name: name,
          surname: surname,
          email: email,
          password: password,
        ),
      ).called(1);
      verify(
        () => firebaseUserService.addUserPersonalData(
          userDto: const UserDto(
            id: userId,
            name: name,
            surname: surname,
          ),
        ),
      ).called(1);
    },
  );

  test(
    'sign up, '
    'email already in user firebase exception, '
    'should throw email already in use auth exception',
    () async {
      const String name = 'Jack';
      const String surname = 'Gadovsky';
      const String email = 'email@example.com';
      const String password = 'password123';
      const AuthException expectedException = AuthException.emailAlreadyInUse;
      firebaseAuthService.mockSignUp(
        throwable: FirebaseAuthExceptionCode.emailAlreadyInUse,
      );
      firebaseUserService.mockAddUserPersonalData();

      Object? exception;
      try {
        await service.signUp(
          name: name,
          surname: surname,
          email: email,
          password: password,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.signUp(
          name: name,
          surname: surname,
          email: email,
          password: password,
        ),
      ).called(1);
      verifyNever(
        () => firebaseUserService.addUserPersonalData(
          userDto: any(named: 'userDto'),
        ),
      );
    },
  );

  test(
    'sign up, '
    'unknown exception, '
    'should rethrow exception',
    () async {
      const String name = 'Jack';
      const String surname = 'Gadovsky';
      const String email = 'email@example.com';
      const String password = 'password123';
      const String expectedException = 'Unknown exception..';
      firebaseAuthService.mockSignUp(
        throwable: expectedException,
      );
      firebaseUserService.mockAddUserPersonalData();

      Object? exception;
      try {
        await service.signUp(
          name: name,
          surname: surname,
          email: email,
          password: password,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseAuthService.signUp(
          name: name,
          surname: surname,
          email: email,
          password: password,
        ),
      ).called(1);
      verifyNever(
        () => firebaseUserService.addUserPersonalData(
          userDto: any(named: 'userDto'),
        ),
      );
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
    'invalid email firebase exception, '
    'should throw invalid email auth exception',
    () async {
      const String email = 'email@example.com';
      const AuthException expectedException = AuthException.invalidEmail;
      firebaseAuthService.mockSendPasswordResetEmail(
        throwable: FirebaseAuthExceptionCode.invalidEmail,
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
    'user not found firebase exception, '
    'should throw user not found auth exception',
    () async {
      const String email = 'email@example.com';
      const AuthException expectedException = AuthException.userNotFound;
      firebaseAuthService.mockSendPasswordResetEmail(
        throwable: FirebaseAuthExceptionCode.userNotFound,
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
    'should rethrow exception',
    () async {
      const String email = 'email@example.com';
      const String expectedException = 'Unknown exception...';
      firebaseAuthService.mockSendPasswordResetEmail(
        throwable: expectedException,
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
    'wrong password firebase exception, '
    'should throw wrong password auth exception',
    () async {
      const String newEmail = 'email@example.com';
      const String password = 'password1';
      const AuthException expectedException = AuthException.wrongPassword;
      firebaseAuthService.mockUpdateEmail(
        throwable: FirebaseAuthExceptionCode.wrongPassword,
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
    'email already in use firebase exception, '
    'should throw email already in use auth exception',
    () async {
      const String newEmail = 'email@example.com';
      const String password = 'password1';
      const AuthException expectedException = AuthException.emailAlreadyInUse;
      firebaseAuthService.mockUpdateEmail(
        throwable: FirebaseAuthExceptionCode.emailAlreadyInUse,
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
    'should rethrow exception',
    () async {
      const String newEmail = 'email@example.com';
      const String password = 'password1';
      const String expectedException = 'Unknown exception...';
      firebaseAuthService.mockUpdateEmail(
        throwable: expectedException,
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
}
