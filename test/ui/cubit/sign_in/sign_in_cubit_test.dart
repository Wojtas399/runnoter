import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/additional_model/custom_exception.dart';
import 'package:runnoter/data/interface/repository/user_repository.dart';
import 'package:runnoter/data/interface/service/auth_service.dart';
import 'package:runnoter/ui/cubit/sign_in/sign_in_cubit.dart';
import 'package:runnoter/ui/model/cubit_status.dart';

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
    GetIt.I.registerFactory<AuthService>(() => authService);
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
    build: () => SignInCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      authService.mockHasLoggedUserVerifiedEmail(expected: true);
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const SignInState(status: CubitStatusLoading()),
      const SignInState(
        status: CubitStatusComplete<SignInCubitInfo>(
          info: SignInCubitInfo.signedIn,
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
    build: () => SignInCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      authService.mockHasLoggedUserVerifiedEmail(expected: false);
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const SignInState(status: CubitStatusLoading()),
      const SignInState(status: CubitStatusComplete()),
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
    build: () => SignInCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const SignInState(status: CubitStatusLoading()),
      const SignInState(status: CubitStatusComplete()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'email changed, '
    'should update email in state',
    build: () => SignInCubit(),
    act: (cubit) => cubit.emailChanged(email),
    expect: () => [
      const SignInState(status: CubitStatusComplete(), email: email),
    ],
  );

  blocTest(
    'password changed, '
    'should update password in state',
    build: () => SignInCubit(),
    act: (cubit) => cubit.passwordChanged(password),
    expect: () => [
      const SignInState(status: CubitStatusComplete(), password: password),
    ],
  );

  blocTest(
    'submit, '
    'logged user has not been found, '
    'should emit complete status without any info',
    build: () => SignInCubit(
      initialState: const SignInState(
        status: CubitStatusInitial(),
        email: email,
        password: password,
      ),
    ),
    setUp: () {
      authService.mockSignIn();
      authService.mockHasLoggedUserVerifiedEmail();
    },
    act: (cubit) => cubit.submit(),
    expect: () => [
      const SignInState(
        status: CubitStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: CubitStatusComplete(),
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
    build: () => SignInCubit(
      initialState: const SignInState(
        status: CubitStatusInitial(),
        email: email,
        password: password,
      ),
    ),
    setUp: () {
      authService.mockSignIn();
      authService.mockHasLoggedUserVerifiedEmail(expected: true);
    },
    act: (cubit) => cubit.submit(),
    expect: () => [
      const SignInState(
        status: CubitStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: CubitStatusComplete<SignInCubitInfo>(
          info: SignInCubitInfo.signedIn,
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
    build: () => SignInCubit(
      initialState: const SignInState(
        status: CubitStatusInitial(),
        email: email,
        password: password,
      ),
    ),
    setUp: () {
      authService.mockSignIn();
      authService.mockHasLoggedUserVerifiedEmail(expected: false);
      authService.mockSendEmailVerification();
    },
    act: (cubit) => cubit.submit(),
    expect: () => [
      const SignInState(
        status: CubitStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: CubitStatusError<SignInCubitError>(
          error: SignInCubitError.unverifiedEmail,
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
    build: () => SignInCubit(
      initialState: const SignInState(
        status: CubitStatusInitial(),
        email: email,
        password: password,
      ),
    ),
    setUp: () => authService.mockSignIn(
      throwable: const AuthException(code: AuthExceptionCode.invalidEmail),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const SignInState(
        status: CubitStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: CubitStatusError<SignInCubitError>(
          error: SignInCubitError.invalidEmail,
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
    build: () => SignInCubit(
      initialState: const SignInState(
        status: CubitStatusInitial(),
        email: email,
        password: password,
      ),
    ),
    setUp: () => authService.mockSignIn(
      throwable: const AuthException(code: AuthExceptionCode.userNotFound),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const SignInState(
        status: CubitStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: CubitStatusError<SignInCubitError>(
          error: SignInCubitError.userNotFound,
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
    build: () => SignInCubit(
      initialState: const SignInState(
        status: CubitStatusInitial(),
        email: email,
        password: password,
      ),
    ),
    setUp: () => authService.mockSignIn(
      throwable: const AuthException(code: AuthExceptionCode.wrongPassword),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const SignInState(
        status: CubitStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: CubitStatusError<SignInCubitError>(
          error: SignInCubitError.wrongPassword,
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
    build: () => SignInCubit(
      initialState: const SignInState(
        status: CubitStatusInitial(),
        email: email,
        password: password,
      ),
    ),
    setUp: () => authService.mockSignIn(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const SignInState(
        status: CubitStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: CubitStatusNoInternetConnection(),
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
    build: () => SignInCubit(
      initialState: const SignInState(
        status: CubitStatusInitial(),
        email: email,
        password: password,
      ),
    ),
    setUp: () => authService.mockSignIn(
      throwable: const UnknownException(message: 'unknown exception message'),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const SignInState(
        status: CubitStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: CubitStatusUnknownError(),
        email: email,
        password: password,
      ),
    ],
    errors: () => [
      const UnknownException(message: 'unknown exception message'),
    ],
    verify: (_) => verify(
      () => authService.signIn(email: email, password: password),
    ).called(1),
  );

  blocTest(
    'submit, '
    'email is empty, '
    'should do nothing',
    build: () => SignInCubit(
      initialState: const SignInState(
        status: CubitStatusInitial(),
        email: '',
        password: password,
      ),
    ),
    act: (cubit) => cubit.submit(),
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
    build: () => SignInCubit(
      initialState: const SignInState(
        status: CubitStatusInitial(),
        email: email,
        password: '',
      ),
    ),
    act: (cubit) => cubit.submit(),
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
    build: () => SignInCubit(),
    setUp: () {
      authService.mockSignInWithGoogle(userId: 'u1');
      userRepository.mockGetUserById(user: createUser(id: 'u1'));
      authService.mockHasLoggedUserVerifiedEmail(expected: true);
    },
    act: (cubit) => cubit.signInWithGoogle(),
    expect: () => [
      const SignInState(status: CubitStatusLoading()),
      const SignInState(
        status: CubitStatusComplete<SignInCubitInfo>(
          info: SignInCubitInfo.signedIn,
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
    build: () => SignInCubit(),
    setUp: () {
      authService.mockSignInWithGoogle(userId: 'u1');
      userRepository.mockGetUserById(user: createUser(id: 'u1'));
      authService.mockHasLoggedUserVerifiedEmail(expected: false);
      authService.mockSendEmailVerification();
    },
    act: (cubit) => cubit.signInWithGoogle(),
    expect: () => [
      const SignInState(status: CubitStatusLoading()),
      const SignInState(
        status: CubitStatusError<SignInCubitError>(
          error: SignInCubitError.unverifiedEmail,
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
    build: () => SignInCubit(),
    setUp: () {
      authService.mockSignInWithGoogle(userId: 'u1');
      userRepository.mockGetUserById();
    },
    act: (cubit) => cubit.signInWithGoogle(),
    expect: () => [
      const SignInState(status: CubitStatusLoading()),
      const SignInState(
        status: CubitStatusComplete<SignInCubitInfo>(
          info: SignInCubitInfo.newSignedInUser,
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
    'signed in user has not been found, '
    'should emit complete status without info',
    build: () => SignInCubit(),
    setUp: () => authService.mockSignInWithGoogle(),
    act: (cubit) => cubit.signInWithGoogle(),
    expect: () => [
      const SignInState(status: CubitStatusLoading()),
      const SignInState(status: CubitStatusComplete()),
    ],
    verify: (_) => verify(authService.signInWithGoogle).called(1),
  );

  blocTest(
    'sign in with google, '
    'network exception with requestFailed code'
    'should emit network request failed status',
    build: () => SignInCubit(),
    setUp: () => authService.mockSignInWithGoogle(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (cubit) => cubit.signInWithGoogle(),
    expect: () => [
      const SignInState(status: CubitStatusLoading()),
      const SignInState(status: CubitStatusNoInternetConnection()),
    ],
    verify: (_) => verify(authService.signInWithGoogle).called(1),
  );

  blocTest(
    'sign in with facebook, '
    'existing user with verified email, '
    'should emit complete status with signed in info',
    build: () => SignInCubit(),
    setUp: () {
      authService.mockSignInWithFacebook(userId: 'u1');
      userRepository.mockGetUserById(user: createUser(id: 'u1'));
      authService.mockHasLoggedUserVerifiedEmail(expected: true);
    },
    act: (cubit) => cubit.signInWithFacebook(),
    expect: () => [
      const SignInState(status: CubitStatusLoading()),
      const SignInState(
        status: CubitStatusComplete<SignInCubitInfo>(
          info: SignInCubitInfo.signedIn,
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
    build: () => SignInCubit(),
    setUp: () {
      authService.mockSignInWithFacebook(userId: 'u1');
      userRepository.mockGetUserById(user: createUser(id: 'u1'));
      authService.mockHasLoggedUserVerifiedEmail(expected: false);
      authService.mockSendEmailVerification();
    },
    act: (cubit) => cubit.signInWithFacebook(),
    expect: () => [
      const SignInState(status: CubitStatusLoading()),
      const SignInState(
        status: CubitStatusError<SignInCubitError>(
          error: SignInCubitError.unverifiedEmail,
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
    build: () => SignInCubit(),
    setUp: () {
      authService.mockSignInWithFacebook(userId: 'u1');
      userRepository.mockGetUserById();
    },
    act: (cubit) => cubit.signInWithFacebook(),
    expect: () => [
      const SignInState(status: CubitStatusLoading()),
      const SignInState(
        status: CubitStatusComplete<SignInCubitInfo>(
          info: SignInCubitInfo.newSignedInUser,
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
    'signed in user has not been found, '
    'should emit complete status without info',
    build: () => SignInCubit(),
    setUp: () => authService.mockSignInWithFacebook(),
    act: (cubit) => cubit.signInWithFacebook(),
    expect: () => [
      const SignInState(status: CubitStatusLoading()),
      const SignInState(status: CubitStatusComplete()),
    ],
    verify: (_) => verify(authService.signInWithFacebook).called(1),
  );

  blocTest(
    'sign in with facebook, '
    'network exception with requestFailed code'
    'should emit network request failed status',
    build: () => SignInCubit(),
    setUp: () => authService.mockSignInWithFacebook(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (cubit) => cubit.signInWithFacebook(),
    expect: () => [
      const SignInState(status: CubitStatusLoading()),
      const SignInState(status: CubitStatusNoInternetConnection()),
    ],
    verify: (_) => verify(authService.signInWithFacebook).called(1),
  );

  blocTest(
    'delete recently created account, '
    'should call auth service method to delete logged user and should emit complete status',
    build: () => SignInCubit(),
    setUp: () => authService.mockDeleteAccount(),
    act: (cubit) => cubit.deleteRecentlyCreatedAccount(),
    expect: () => [
      const SignInState(status: CubitStatusLoading()),
      const SignInState(status: CubitStatusComplete()),
    ],
    verify: (_) => verify(authService.deleteAccount).called(1),
  );
}
