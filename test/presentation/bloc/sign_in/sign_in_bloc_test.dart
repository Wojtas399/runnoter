import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/auth_exception.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/sign_in/bloc/sign_in_bloc.dart';
import 'package:runnoter/presentation/screen/sign_in/bloc/sign_in_event.dart';
import 'package:runnoter/presentation/screen/sign_in/bloc/sign_in_state.dart';

import '../../../mock/mock_auth_service.dart';
import '../../../mock/presentation/service/mock_connectivity_service.dart';

void main() {
  final authService = MockAuthService();
  final connectivityService = MockConnectivityService();
  const String email = 'email@example.com';
  const String password = 'Password1!';

  SignInBloc createBloc({
    final String? email,
    final String? password,
  }) {
    return SignInBloc(
      authService: authService,
      connectivityService: connectivityService,
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
    reset(connectivityService);
  });

  blocTest(
    'email changed, '
    'should update email in state',
    build: () => createBloc(),
    act: (SignInBloc bloc) {
      bloc.add(
        const SignInEventEmailChanged(
          email: email,
        ),
      );
    },
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
    act: (SignInBloc bloc) {
      bloc.add(
        const SignInEventPasswordChanged(
          password: password,
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        password: password,
      ),
    ],
  );

  blocTest(
    'submit, '
    'email and password are not empty, '
    "email doesn't have internet connection, "
    'should emit error status with no internet connection error',
    build: () => createBloc(
      email: email,
      password: password,
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(
        hasConnection: false,
      );
    },
    act: (SignInBloc bloc) {
      bloc.add(
        const SignInEventSubmit(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        email: email,
        password: password,
      ),
      createState(
        status: const BlocStatusError<SignInError>(
          error: SignInError.noInternetConnection,
        ),
        email: email,
        password: password,
      ),
    ],
    verify: (_) {
      verifyNever(
        () => authService.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    },
  );

  blocTest(
    'submit, '
    'email and password are not empty, '
    'device has internet connection, '
    'should call method responsible for signing in user and should emit complete status with signed in info',
    build: () => createBloc(
      email: email,
      password: password,
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(
        hasConnection: true,
      );
      authService.mockSignIn();
    },
    act: (SignInBloc bloc) {
      bloc.add(
        const SignInEventSubmit(),
      );
    },
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
    verify: (_) {
      verify(
        () => connectivityService.hasDeviceInternetConnection(),
      ).called(1);
      verify(
        () => authService.signIn(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'email and password are not empty, '
    'device has internet connection, '
    'auth service method throws invalid email auth exception, '
    'should emit error status with invalid email error',
    build: () => createBloc(
      email: email,
      password: password,
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(
        hasConnection: true,
      );
      authService.mockSignIn(
        throwable: AuthException.invalidEmail,
      );
    },
    act: (SignInBloc bloc) {
      bloc.add(
        const SignInEventSubmit(),
      );
    },
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
    verify: (_) {
      verify(
        () => connectivityService.hasDeviceInternetConnection(),
      ).called(1);
      verify(
        () => authService.signIn(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'email and password are not empty, '
    'device has internet connection, '
    'auth service method throws user not found auth exception, '
    'should emit error status with user not found error',
    build: () => createBloc(
      email: email,
      password: password,
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(
        hasConnection: true,
      );
      authService.mockSignIn(
        throwable: AuthException.userNotFound,
      );
    },
    act: (SignInBloc bloc) {
      bloc.add(
        const SignInEventSubmit(),
      );
    },
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
    verify: (_) {
      verify(
        () => connectivityService.hasDeviceInternetConnection(),
      ).called(1);
      verify(
        () => authService.signIn(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'email and password are not empty, '
    'device has internet connection, '
    'auth service method throws wrong password auth exception, '
    'should emit error status with wrong password error',
    build: () => createBloc(
      email: email,
      password: password,
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(
        hasConnection: true,
      );
      authService.mockSignIn(
        throwable: AuthException.wrongPassword,
      );
    },
    act: (SignInBloc bloc) {
      bloc.add(
        const SignInEventSubmit(),
      );
    },
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
    verify: (_) {
      verify(
        () => connectivityService.hasDeviceInternetConnection(),
      ).called(1);
      verify(
        () => authService.signIn(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'email is empty, '
    'should do nothing',
    build: () => createBloc(
      email: '',
      password: password,
    ),
    act: (SignInBloc bloc) {
      bloc.add(
        const SignInEventSubmit(),
      );
    },
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => connectivityService.hasDeviceInternetConnection(),
      );
      verifyNever(
        () => authService.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    },
  );

  blocTest(
    'submit, '
    'password is empty, '
    'should do nothing',
    build: () => createBloc(
      email: email,
      password: '',
    ),
    act: (SignInBloc bloc) {
      bloc.add(
        const SignInEventSubmit(),
      );
    },
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => connectivityService.hasDeviceInternetConnection(),
      );
      verifyNever(
        () => authService.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    },
  );
}
