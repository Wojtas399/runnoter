import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/bloc/sign_in/sign_in_bloc.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  const String loggedUserId = 'u1';
  const String email = 'email@example.com';
  const String password = 'Password1!';

  setUpAll(() {
    GetIt.I.registerSingleton<AuthService>(authService);
  });

  tearDown(() {
    reset(authService);
  });

  blocTest(
    'initialize, '
    'logged user id is not null, '
    'should emit complete status with signed in info',
    build: () => SignInBloc(),
    setUp: () => authService.mockGetLoggedUserId(userId: loggedUserId),
    act: (bloc) => bloc.add(const SignInEventInitialize()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(
        status: BlocStatusComplete<SignInInfo>(info: SignInInfo.signedIn),
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'logged user id is null, '
    'should emit complete status without any info',
    build: () => SignInBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const SignInEventInitialize()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(status: BlocStatusComplete<SignInInfo>()),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'email changed, '
    'should update email in state',
    build: () => SignInBloc(),
    act: (bloc) => bloc.add(const SignInEventEmailChanged(email: email)),
    expect: () => [
      const SignInState(
        status: BlocStatusComplete(),
        email: email,
      ),
    ],
  );

  blocTest(
    'password changed, '
    'should update password in state',
    build: () => SignInBloc(),
    act: (bloc) =>
        bloc.add(const SignInEventPasswordChanged(password: password)),
    expect: () => [
      const SignInState(
        status: BlocStatusComplete(),
        password: password,
      ),
    ],
  );

  blocTest(
    'submit, '
    'should call method responsible for signing in user and should emit complete status with signed in info',
    build: () => SignInBloc(
      email: email,
      password: password,
    ),
    setUp: () => authService.mockSignIn(),
    act: (bloc) => bloc.add(const SignInEventSubmit()),
    expect: () => [
      const SignInState(
        status: BlocStatusLoading(),
        email: email,
        password: password,
      ),
      const SignInState(
        status: BlocStatusComplete<SignInInfo>(
          info: SignInInfo.signedIn,
        ),
        email: email,
        password: password,
      ),
    ],
    verify: (_) => verify(
      () => authService.signIn(
        email: email,
        password: password,
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'auth exception with invalid email code, '
    'should emit error status with invalid email error',
    build: () => SignInBloc(
      email: email,
      password: password,
    ),
    setUp: () => authService.mockSignIn(
      throwable: const AuthException(
        code: AuthExceptionCode.invalidEmail,
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
        status: BlocStatusError<SignInError>(
          error: SignInError.invalidEmail,
        ),
        email: email,
        password: password,
      ),
    ],
    verify: (_) => verify(
      () => authService.signIn(
        email: email,
        password: password,
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'auth exception with user not found code, '
    'should emit error status with user not found error',
    build: () => SignInBloc(
      email: email,
      password: password,
    ),
    setUp: () => authService.mockSignIn(
      throwable: const AuthException(
        code: AuthExceptionCode.userNotFound,
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
        status: BlocStatusError<SignInError>(
          error: SignInError.userNotFound,
        ),
        email: email,
        password: password,
      ),
    ],
    verify: (_) => verify(
      () => authService.signIn(
        email: email,
        password: password,
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'auth exception with wrong password code, '
    'should emit error status with wrong password error',
    build: () => SignInBloc(
      email: email,
      password: password,
    ),
    setUp: () => authService.mockSignIn(
      throwable: const AuthException(
        code: AuthExceptionCode.wrongPassword,
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
        status: BlocStatusError<SignInError>(
          error: SignInError.wrongPassword,
        ),
        email: email,
        password: password,
      ),
    ],
    verify: (_) => verify(
      () => authService.signIn(
        email: email,
        password: password,
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'network exception with request failed code, '
    'should emit network request failed status',
    build: () => SignInBloc(
      email: email,
      password: password,
    ),
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
      () => authService.signIn(
        email: email,
        password: password,
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'unknown exception, '
    'should emit unknown error status',
    build: () => SignInBloc(
      email: email,
      password: password,
    ),
    setUp: () => authService.mockSignIn(
      throwable: const UnknownException(
        message: 'unknown exception message',
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
        status: BlocStatusUnknownError(),
        email: email,
        password: password,
      ),
    ],
    errors: () => ['unknown exception message'],
    verify: (_) => verify(
      () => authService.signIn(
        email: email,
        password: password,
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'email is empty, '
    'should do nothing',
    build: () => SignInBloc(
      email: '',
      password: password,
    ),
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
    build: () => SignInBloc(
      email: email,
      password: '',
    ),
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
    "should call auth service's method to sign in with google and should emit complete status with signed in info if logged user id is not null",
    build: () => SignInBloc(),
    setUp: () {
      authService.mockSignInWithGoogle();
      authService.mockGetLoggedUserId(userId: 'u1');
    },
    act: (bloc) => bloc.add(const SignInEventSignInWithGoogle()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(
        status: BlocStatusComplete<SignInInfo>(info: SignInInfo.signedIn),
      ),
    ],
    verify: (_) {
      verify(() => authService.signInWithGoogle()).called(1);
      verify(() => authService.loggedUserId$).called(1);
    },
  );

  blocTest(
    'sign in with google, '
    "should call auth service's method to sign in with google and should emit complete status without info if logged user id is null",
    build: () => SignInBloc(),
    setUp: () {
      authService.mockSignInWithGoogle();
      authService.mockGetLoggedUserId();
    },
    act: (bloc) => bloc.add(const SignInEventSignInWithGoogle()),
    expect: () => [
      const SignInState(status: BlocStatusLoading()),
      const SignInState(
        status: BlocStatusComplete<SignInInfo>(),
      ),
    ],
    verify: (_) {
      verify(() => authService.signInWithGoogle()).called(1);
      verify(() => authService.loggedUserId$).called(1);
    },
  );
}
