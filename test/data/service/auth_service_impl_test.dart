import 'package:firebase/model/exception/firebase_auth_exception_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/service_impl/auth_service_impl.dart';
import 'package:runnoter/domain/model/auth_exception.dart';

import '../../mock/firebase/mock_firebase_auth_service.dart';
import '../../mock/firebase/mock_firebase_user_service.dart';

void main() {
  final firebaseAuthService = MockFirebaseAuthService();
  final firebaseUserService = MockFirebaseUserService();
  late AuthServiceImpl service;

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

  group(
    'sign in',
    () {
      const String email = 'email@example.com';
      const String password = 'password123';

      Future<void> callMethod() async {
        await service.signIn(email: email, password: password);
      }

      tearDown(() {
        verify(
          () => firebaseAuthService.signIn(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test(
        'should call firebase method responsible for signing in user',
        () async {
          firebaseAuthService.mockSignIn();

          await callMethod();
        },
      );

      test(
        'firebase invalid email exception, should throw auth exception with invalidEmail type',
        () async {
          const expectedAuthException = AuthException.invalidEmail;
          firebaseAuthService.mockSignIn(
            throwable: FirebaseAuthExceptionCode.invalidEmail,
          );

          Object? exception;
          try {
            await callMethod();
          } catch (e) {
            exception = e;
          }

          expect(exception, expectedAuthException);
        },
      );

      test(
        'firebase user not found exception, should throw auth exception with userNotFound type',
        () async {
          const expectedAuthException = AuthException.userNotFound;
          firebaseAuthService.mockSignIn(
            throwable: FirebaseAuthExceptionCode.userNotFound,
          );

          Object? exception;
          try {
            await callMethod();
          } catch (e) {
            exception = e;
          }

          expect(exception, expectedAuthException);
        },
      );

      test(
        'firebase wrong password exception, should throw auth exception with wrongPassword type',
        () async {
          const expectedAuthException = AuthException.wrongPassword;
          firebaseAuthService.mockSignIn(
            throwable: FirebaseAuthExceptionCode.wrongPassword,
          );

          Object? exception;
          try {
            await callMethod();
          } catch (e) {
            exception = e;
          }

          expect(exception, expectedAuthException);
        },
      );

      test(
        'unknown exception, should rethrow exception',
        () async {
          const expectedException = 'Exception info';
          firebaseAuthService.mockSignIn(throwable: expectedException);

          Object? exception;
          try {
            await callMethod();
          } catch (e) {
            exception = e;
          }

          expect(exception, expectedException);
        },
      );
    },
  );

  group(
    'sign up',
    () {
      const String name = 'Jack';
      const String surname = 'Gadovsky';
      const String email = 'jack@example.com';
      const String password = 'Password123!';

      Future<void> callMethod() async {
        await service.signUp(
          name: name,
          surname: surname,
          email: email,
          password: password,
        );
      }

      tearDown(() {
        verify(
          () => firebaseAuthService.signUp(
            name: name,
            surname: surname,
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test(
        "should call firebase methods responsible for signing up user and responsible for adding user's personal data",
        () async {
          const String userId = 'u1';
          firebaseAuthService.mockSignUp(userId: userId);
          firebaseUserService.mockAddUserPersonalData();

          await callMethod();

          verify(
            () => firebaseUserService.addUserPersonalData(
              userId: userId,
              name: name,
              surname: surname,
            ),
          ).called(1);
        },
      );

      test(
        'firebase email already in use exception, should throw auth exception with emailAlreadyInUse type',
        () async {
          const expectedAuthException = AuthException.emailAlreadyInUse;
          firebaseAuthService.mockSignUp(
            throwable: FirebaseAuthExceptionCode.emailAlreadyInUse,
          );

          Object? exception;
          try {
            await callMethod();
          } catch (e) {
            exception = e;
          }

          expect(exception, expectedAuthException);
          verifyNever(
            () => firebaseUserService.addUserPersonalData(
              userId: any(named: 'userId'),
              name: name,
              surname: surname,
            ),
          );
        },
      );

      test(
        'unknown exception, should rethrow exception',
        () async {
          const expectedException = 'Exception info';
          firebaseAuthService.mockSignUp(throwable: expectedException);

          Object? exception;
          try {
            await callMethod();
          } catch (e) {
            exception = e;
          }

          expect(exception, expectedException);
          verifyNever(
            () => firebaseUserService.addUserPersonalData(
              userId: any(named: 'userId'),
              name: name,
              surname: surname,
            ),
          );
        },
      );
    },
  );

  group(
    'send password reset email',
    () {
      const String email = 'email@example.com';

      Future<void> callMethod() async {
        await service.sendPasswordResetEmail(email: email);
      }

      tearDown(() {
        verify(
          () => firebaseAuthService.sendPasswordResetEmail(
            email: email,
          ),
        ).called(1);
      });

      test(
        'should call method responsible for sending password reset email',
        () async {
          firebaseAuthService.mockSendPasswordResetEmail();

          await callMethod();
        },
      );

      test(
        'firebase invalid email exception, should throw auth exception with invalidEmail type',
        () async {
          const expectedAuthException = AuthException.invalidEmail;
          firebaseAuthService.mockSendPasswordResetEmail(
            throwable: FirebaseAuthExceptionCode.invalidEmail,
          );

          Object? exception;
          try {
            await callMethod();
          } catch (e) {
            exception = e;
          }

          expect(exception, expectedAuthException);
        },
      );

      test(
        'firebase user not found exception, should throw auth exception with userNotFound type',
        () async {
          const expectedAuthException = AuthException.userNotFound;
          firebaseAuthService.mockSendPasswordResetEmail(
            throwable: FirebaseAuthExceptionCode.userNotFound,
          );

          Object? exception;
          try {
            await callMethod();
          } catch (e) {
            exception = e;
          }

          expect(exception, expectedAuthException);
        },
      );

      test(
        'unknown exception, should rethrow exception',
        () async {
          const expectedException = 'Exception info';
          firebaseAuthService.mockSendPasswordResetEmail(
            throwable: expectedException,
          );

          Object? exception;
          try {
            await callMethod();
          } catch (e) {
            exception = e;
          }

          expect(exception, expectedException);
        },
      );
    },
  );
}
