import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/bloc/sign_in/sign_in_bloc.dart';
import 'package:runnoter/domain/repository/user_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../creators/user_creator.dart';
import '../../../mock/domain/repository/mock_user_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  const String loggedUserId = 'u1';
  const String email = 'email@example.com';
  const String password = 'Password1!';

  setUpAll(() {
    GetIt.I.registerSingleton<AuthService>(authService);
    GetIt.I.registerSingleton<UserRepository>(userRepository);
  });

  tearDown(() {
    reset(authService);
    reset(userRepository);
  });

  blocTest(
    'initialize, '
    'logged user exists and has verified email, '
    'should emit complete status with signed in info',
    build: () => SignInBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      authService.mockHasLoggedUserVerifiedEmail(expected: true);
    },
    act: (bloc) => bloc.add(const SignInEventInitialize()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(
        status: BlocStatusComplete<SignInBlocInfo>(
          info: SignInBlocInfo.signedIn,
        ),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(() => authService.hasLoggedUserVerifiedEmail$).called(1);
    },
  );

  blocTest(
    'initialize, '
    'logged user exists and has unverified email, '
    'should emit complete status without any info',
    build: () => SignInBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      authService.mockHasLoggedUserVerifiedEmail(expected: false);
    },
    act: (bloc) => bloc.add(const SignInEventInitialize()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(status: BlocStatusComplete<SignInBlocInfo>()),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(() => authService.hasLoggedUserVerifiedEmail$).called(1);
    },
  );

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should emit complete status without any info',
    build: () => SignInBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const SignInEventInitialize()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(status: BlocStatusComplete<SignInBlocInfo>()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'email changed, '
    'should update email in state',
    build: () => SignInBloc(),
    act: (bloc) => bloc.add(const SignInEventEmailChanged(email: email)),
    expect: () => [
      const SignInState(status: BlocStatusComplete(), email: email),
    ],
  );

  blocTest(
    'password changed, '
    'should update password in state',
    build: () => SignInBloc(),
    act: (bloc) => bloc.add(const SignInEventPasswordChanged(
      password: password,
    )),
    expect: () => [
      const SignInState(status: BlocStatusComplete(), password: password),
    ],
  );

  blocTest(
    'submit, '
    'logged user does not exist, '
    'should emit complete status without any info',
    build: () => SignInBloc(email: email, password: password),
    setUp: () {
      authService.mockSignIn();
      authService.mockHasLoggedUserVerifiedEmail();
    },
    act: (bloc) => bloc.add(const SignInEventSubmit()),
    expect: () => [
      const SignInState(
        status: BlocStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: BlocStatusComplete<SignInBlocInfo>(),
        email: email,
        password: password,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.signIn(email: email, password: password),
      ).called(1);
      verify(() => authService.hasLoggedUserVerifiedEmail$).called(1);
    },
  );

  blocTest(
    'submit, '
    'user has verified email, '
    'should emit complete status with signed in info',
    build: () => SignInBloc(email: email, password: password),
    setUp: () {
      authService.mockSignIn();
      authService.mockHasLoggedUserVerifiedEmail(expected: true);
    },
    act: (bloc) => bloc.add(const SignInEventSubmit()),
    expect: () => [
      const SignInState(
        status: BlocStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: BlocStatusComplete<SignInBlocInfo>(
          info: SignInBlocInfo.signedIn,
        ),
        email: email,
        password: password,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.signIn(email: email, password: password),
      ).called(1);
      verify(() => authService.hasLoggedUserVerifiedEmail$).called(1);
    },
  );

  blocTest(
    'submit, '
    'user has not verified email, '
    "should emit error status with unverified email error and should call auth service's method to send email verification",
    build: () => SignInBloc(email: email, password: password),
    setUp: () {
      authService.mockSignIn();
      authService.mockHasLoggedUserVerifiedEmail(expected: false);
      authService.mockSendEmailVerification();
    },
    act: (bloc) => bloc.add(const SignInEventSubmit()),
    expect: () => [
      const SignInState(
        status: BlocStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: BlocStatusError<SignInBlocError>(
          error: SignInBlocError.unverifiedEmail,
        ),
        email: email,
        password: password,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.signIn(email: email, password: password),
      ).called(1);
      verify(() => authService.hasLoggedUserVerifiedEmail$).called(1);
      verify(authService.sendEmailVerification).called(1);
    },
  );

  blocTest(
    'submit, '
    'auth exception with invalid email code, '
    'should emit error status with invalid email error',
    build: () => SignInBloc(email: email, password: password),
    setUp: () => authService.mockSignIn(
      throwable: const AuthException(code: AuthExceptionCode.invalidEmail),
    ),
    act: (bloc) => bloc.add(const SignInEventSubmit()),
    expect: () => [
      const SignInState(
        status: BlocStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: BlocStatusError<SignInBlocError>(
          error: SignInBlocError.invalidEmail,
        ),
        email: email,
        password: password,
      ),
    ],
    verify: (_) => verify(
      () => authService.signIn(email: email, password: password),
    ).called(1),
  );

  blocTest(
    'submit, '
    'auth exception with user not found code, '
    'should emit error status with user not found error',
    build: () => SignInBloc(email: email, password: password),
    setUp: () => authService.mockSignIn(
      throwable: const AuthException(code: AuthExceptionCode.userNotFound),
    ),
    act: (bloc) => bloc.add(const SignInEventSubmit()),
    expect: () => [
      const SignInState(
        status: BlocStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: BlocStatusError<SignInBlocError>(
          error: SignInBlocError.userNotFound,
        ),
        email: email,
        password: password,
      ),
    ],
    verify: (_) => verify(
      () => authService.signIn(email: email, password: password),
    ).called(1),
  );

  blocTest(
    'submit, '
    'auth exception with wrong password code, '
    'should emit error status with wrong password error',
    build: () => SignInBloc(email: email, password: password),
    setUp: () => authService.mockSignIn(
      throwable: const AuthException(code: AuthExceptionCode.wrongPassword),
    ),
    act: (bloc) => bloc.add(const SignInEventSubmit()),
    expect: () => [
      const SignInState(
        status: BlocStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: BlocStatusError<SignInBlocError>(
          error: SignInBlocError.wrongPassword,
        ),
        email: email,
        password: password,
      ),
    ],
    verify: (_) => verify(
      () => authService.signIn(email: email, password: password),
    ).called(1),
  );

  blocTest(
    'submit, '
    'network exception with request failed code, '
    'should emit network request failed status',
    build: () => SignInBloc(email: email, password: password),
    setUp: () => authService.mockSignIn(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (bloc) => bloc.add(const SignInEventSubmit()),
    expect: () => [
      const SignInState(
        status: BlocStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: BlocStatusNetworkRequestFailed(),
        email: email,
        password: password,
      ),
    ],
    verify: (_) => verify(
      () => authService.signIn(email: email, password: password),
    ).called(1),
  );

  blocTest(
    'submit, '
    'unknown exception, '
    'should emit unknown error status',
    build: () => SignInBloc(email: email, password: password),
    setUp: () => authService.mockSignIn(
      throwable: const UnknownException(message: 'unknown exception message'),
    ),
    act: (bloc) => bloc.add(const SignInEventSubmit()),
    expect: () => [
      const SignInState(
        status: BlocStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: BlocStatusUnknownError(),
        email: email,
        password: password,
      ),
    ],
    errors: () => ['unknown exception message'],
    verify: (_) => verify(
      () => authService.signIn(email: email, password: password),
    ).called(1),
  );

  blocTest(
    'submit, '
    'email is empty, '
    'should do nothing',
    build: () => SignInBloc(email: '', password: password),
    act: (bloc) => bloc.add(const SignInEventSubmit()),
    expect: () => [],
    verify: (_) => verifyNever(
      () => authService.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ),
  );

  blocTest(
    'submit, '
    'password is empty, '
    'should do nothing',
    build: () => SignInBloc(email: email, password: ''),
    act: (bloc) => bloc.add(const SignInEventSubmit()),
    expect: () => [],
    verify: (_) => verifyNever(
      () => authService.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ),
  );

  blocTest(
    'sign in with google, '
    'existing user with verified email, '
    'should emit complete status with signed in info',
    build: () => SignInBloc(),
    setUp: () {
      authService.mockSignInWithGoogle(userId: 'u1');
      userRepository.mockGetUserById(user: createUser(id: 'u1'));
      authService.mockHasLoggedUserVerifiedEmail(expected: true);
    },
    act: (bloc) => bloc.add(const SignInEventSignInWithGoogle()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(
        status: BlocStatusComplete<SignInBlocInfo>(
          info: SignInBlocInfo.signedIn,
        ),
      ),
    ],
    verify: (_) {
      verify(authService.signInWithGoogle).called(1);
      verify(() => userRepository.getUserById(userId: 'u1')).called(1);
      verify(() => authService.hasLoggedUserVerifiedEmail$).called(1);
    },
  );

  blocTest(
    'sign in with google, '
    'existing user with unverified email, '
    "should emit error status with unverified email error and should call auth service's method to send email verification",
    build: () => SignInBloc(),
    setUp: () {
      authService.mockSignInWithGoogle(userId: 'u1');
      userRepository.mockGetUserById(user: createUser(id: 'u1'));
      authService.mockHasLoggedUserVerifiedEmail(expected: false);
      authService.mockSendEmailVerification();
    },
    act: (bloc) => bloc.add(const SignInEventSignInWithGoogle()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(
        status: BlocStatusError<SignInBlocError>(
          error: SignInBlocError.unverifiedEmail,
        ),
      ),
    ],
    verify: (_) {
      verify(authService.signInWithGoogle).called(1);
      verify(() => userRepository.getUserById(userId: 'u1')).called(1);
      verify(() => authService.hasLoggedUserVerifiedEmail$).called(1);
      verify(authService.sendEmailVerification).called(1);
    },
  );

  blocTest(
    'sign in with google, '
    'new user, '
    'should emit complete status with new signed in user info',
    build: () => SignInBloc(),
    setUp: () {
      authService.mockSignInWithGoogle(userId: 'u1');
      userRepository.mockGetUserById();
    },
    act: (bloc) => bloc.add(const SignInEventSignInWithGoogle()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(
        status: BlocStatusComplete<SignInBlocInfo>(
          info: SignInBlocInfo.newSignedInUser,
        ),
      ),
    ],
    verify: (_) {
      verify(authService.signInWithGoogle).called(1);
      verify(() => userRepository.getUserById(userId: 'u1')).called(1);
    },
  );

  blocTest(
    'sign in with google, '
    'there is no signed in user, '
    'should emit complete status without info',
    build: () => SignInBloc(),
    setUp: () => authService.mockSignInWithGoogle(),
    act: (bloc) => bloc.add(const SignInEventSignInWithGoogle()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(status: BlocStatusComplete<SignInBlocInfo>()),
    ],
    verify: (_) => verify(authService.signInWithGoogle).called(1),
  );

  blocTest(
    'sign in with google, '
    'network exception with requestFailed code'
    'should emit network request failed status',
    build: () => SignInBloc(),
    setUp: () => authService.mockSignInWithGoogle(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (bloc) => bloc.add(const SignInEventSignInWithGoogle()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(status: BlocStatusNetworkRequestFailed()),
    ],
    verify: (_) => verify(authService.signInWithGoogle).called(1),
  );

  blocTest(
    'sign in with facebook, '
    'existing user with verified email, '
    'should emit complete status with signed in info',
    build: () => SignInBloc(),
    setUp: () {
      authService.mockSignInWithFacebook(userId: 'u1');
      userRepository.mockGetUserById(user: createUser(id: 'u1'));
      authService.mockHasLoggedUserVerifiedEmail(expected: true);
    },
    act: (bloc) => bloc.add(const SignInEventSignInWithFacebook()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(
        status: BlocStatusComplete<SignInBlocInfo>(
          info: SignInBlocInfo.signedIn,
        ),
      ),
    ],
    verify: (_) {
      verify(authService.signInWithFacebook).called(1);
      verify(() => userRepository.getUserById(userId: 'u1')).called(1);
      verify(() => authService.hasLoggedUserVerifiedEmail$).called(1);
    },
  );

  blocTest(
    'sign in with facebook, '
    'existing user with unverified email, '
    "should emit error status with unverified email error and should call auth service's method to send email verification",
    build: () => SignInBloc(),
    setUp: () {
      authService.mockSignInWithFacebook(userId: 'u1');
      userRepository.mockGetUserById(user: createUser(id: 'u1'));
      authService.mockHasLoggedUserVerifiedEmail(expected: false);
      authService.mockSendEmailVerification();
    },
    act: (bloc) => bloc.add(const SignInEventSignInWithFacebook()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(
        status: BlocStatusError<SignInBlocError>(
          error: SignInBlocError.unverifiedEmail,
        ),
      ),
    ],
    verify: (_) {
      verify(authService.signInWithFacebook).called(1);
      verify(() => userRepository.getUserById(userId: 'u1')).called(1);
      verify(() => authService.hasLoggedUserVerifiedEmail$).called(1);
      verify(authService.sendEmailVerification).called(1);
    },
  );

  blocTest(
    'sign in with facebook, '
    'new user, '
    'should emit complete status with new signed in user info',
    build: () => SignInBloc(),
    setUp: () {
      authService.mockSignInWithFacebook(userId: 'u1');
      userRepository.mockGetUserById();
    },
    act: (bloc) => bloc.add(const SignInEventSignInWithFacebook()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(
        status: BlocStatusComplete<SignInBlocInfo>(
          info: SignInBlocInfo.newSignedInUser,
        ),
      ),
    ],
    verify: (_) {
      verify(authService.signInWithFacebook).called(1);
      verify(() => userRepository.getUserById(userId: 'u1')).called(1);
    },
  );

  blocTest(
    'sign in with facebook, '
    'there is no signed in user, '
    'should emit complete status without info',
    build: () => SignInBloc(),
    setUp: () => authService.mockSignInWithFacebook(),
    act: (bloc) => bloc.add(const SignInEventSignInWithFacebook()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(status: BlocStatusComplete<SignInBlocInfo>()),
    ],
    verify: (_) => verify(authService.signInWithFacebook).called(1),
  );

  blocTest(
    'sign in with facebook, '
    'network exception with requestFailed code'
    'should emit network request failed status',
    build: () => SignInBloc(),
    setUp: () => authService.mockSignInWithFacebook(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (bloc) => bloc.add(const SignInEventSignInWithFacebook()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(status: BlocStatusNetworkRequestFailed()),
    ],
    verify: (_) => verify(authService.signInWithFacebook).called(1),
  );

  blocTest(
    'delete recently created account, '
    'should call auth service method to delete logged user and should emit complete status',
    build: () => SignInBloc(),
    setUp: () => authService.mockDeleteAccount(),
    act: (bloc) => bloc.add(const SignInEventDeleteRecentlyCreatedAccount()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(status: BlocStatusComplete<SignInBlocInfo>()),
    ],
    verify: (_) => verify(authService.deleteAccount).called(1),
  );

  blocTest(
    'delete recently created account, '
    'should call auth service method to delete logged user and should emit complete status',
    build: () => SignInBloc(),
    setUp: () => authService.mockDeleteAccount(),
    act: (bloc) => bloc.add(const SignInEventDeleteRecentlyCreatedAccount()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(status: BlocStatusComplete<SignInBlocInfo>()),
    ],
    verify: (_) => verify(authService.deleteAccount).called(1),
  );
}
