import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/service_impl/auth_service_impl.dart';
import 'package:runnoter/domain/model/auth_exception.dart';

import '../../mock/firebase/mock_firebase_auth_service.dart';
import '../../mock/firebase/mock_firebase_user_service.dart';

void main() {
  final firebaseAuthService = MockFirebaseAuthService();
  final firebaseUserService = MockFirebaseUserService();
  late AuthServiceImpl auth;

  setUp(() {
    auth = AuthServiceImpl(
      firebaseAuthService: firebaseAuthService,
      firebaseUserService: firebaseUserService,
    );
  });

  group(
    'sign in',
    () {
      const String email = 'email@example.com';
      const String password = 'password123';

      Future<void> callMethod() async {
        await auth.signIn(email: email, password: password);
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
        'firebase method throws invalid email exception, should throw auth exception with invalid email code',
        () async {
          const expectedAuthException = AuthException(
            code: AuthExceptionCode.invalidEmail,
          );
          firebaseAuthService.mockSignIn(
            throwable: FirebaseAuthException(code: 'invalid-email'),
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
        'firebase method throws user not found exception, should throw auth exception with user not found code',
        () async {
          const expectedAuthException = AuthException(
            code: AuthExceptionCode.userNotFound,
          );
          firebaseAuthService.mockSignIn(
            throwable: FirebaseAuthException(code: 'user-not-found'),
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
        'firebase method throws wrong password exception, should throw auth exception with wrong password code',
        () async {
          const expectedAuthException = AuthException(
            code: AuthExceptionCode.wrongPassword,
          );
          firebaseAuthService.mockSignIn(
            throwable: FirebaseAuthException(code: 'wrong-password'),
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
        'firebase method throws unknown exception, should rethrow exception',
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
        await auth.signUp(
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
        "should call firebase methods responsible for signing up user and for add user's personal data",
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
        'firebase sign up method throws email already in use exception, should throw auth exception with email already in use code',
        () async {
          const expectedAuthException = AuthException(
            code: AuthExceptionCode.emailAlreadyInUse,
          );
          firebaseAuthService.mockSignUp(
            throwable: FirebaseAuthException(code: 'email-already-in-use'),
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
        'firebase method throws unknown exception, should rethrow exception',
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
}
