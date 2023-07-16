import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/bloc/sign_in/sign_in_bloc.dart';

import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  const String loggedUserId = 'u1';
  const String email = 'email@example.com';
  const String password = 'Password1!';

  SignInBloc createBloc({
    final String? email,
    final String? password,
  }) {
    return SignInBloc(
      authService: authService,
      email: email ?? '',
      password: password ?? '',
    );
  }

  SignInState createState({
    BlocStatus? status,
    String? email,
    String? password,
  }) {
    final bloc = createBloc();
    return bloc.state.copyWith(
      status: status,
      email: email,
      password: password,
    );
  }

  tearDown(() {
    reset(authService);
  });

  blocTest(
    'initialize, '
    'logged user id is not null, '
    'should emit complete status with signed in info',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(userId: loggedUserId),
    act: (bloc) => bloc.add(const SignInEventInitialize()),
    expect: () => [
      createState(status: const BlocStatusLoading()),
      createState(
        status: const BlocStatusComplete<SignInInfo>(info: SignInInfo.signedIn),
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
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const SignInEventInitialize()),
    expect: () => [
      createState(status: const BlocStatusLoading()),
      createState(status: const BlocStatusComplete<SignInInfo>()),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'email changed, '
    'should update email in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const SignInEventEmailChanged(email: email)),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        email: email,
      ),
    ],
  );

  blocTest(
    'password changed, '
    'should update password in state',
    build: () => createBloc(),
    act: (bloc) =>
        bloc.add(const SignInEventPasswordChanged(password: password)),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        password: password,
      ),
    ],
  );

  blocTest(
    'submit, '
    'should call method responsible for signing in user and should emit complete status with signed in info',
    build: () => createBloc(
      email: email,
      password: password,
    ),
    setUp: () => authService.mockSignIn(),
    act: (bloc) => bloc.add(const SignInEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        email: email,
        password: password,
      ),
      createState(
        status: const BlocStatusComplete<SignInInfo>(
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
    build: () => createBloc(
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
      createState(
        status: const BlocStatusLoading(),
        email: email,
        password: password,
      ),
      createState(
        status: const BlocStatusError<SignInError>(
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
    build: () => createBloc(
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
      createState(
        status: const BlocStatusLoading(),
        email: email,
        password: password,
      ),
      createState(
        status: const BlocStatusError<SignInError>(
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
    build: () => createBloc(
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
      createState(
        status: const BlocStatusLoading(),
        email: email,
        password: password,
      ),
      createState(
        status: const BlocStatusError<SignInError>(
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
    build: () => createBloc(
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
      createState(
        status: const BlocStatusLoading(),
        email: email,
        password: password,
      ),
      createState(
        status: const BlocStatusNetworkRequestFailed(),
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
    build: () => createBloc(
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
      createState(
        status: const BlocStatusLoading(),
        email: email,
        password: password,
      ),
      createState(
        status: const BlocStatusUnknownError(),
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
    build: () => createBloc(
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
    build: () => createBloc(
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
}
