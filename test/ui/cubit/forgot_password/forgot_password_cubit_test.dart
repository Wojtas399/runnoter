import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/model/custom_exception.dart';
import 'package:runnoter/data/service/auth/auth_service.dart';
import 'package:runnoter/ui/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:runnoter/ui/model/cubit_status.dart';

import '../../../mock/data/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  const String email = 'email@example.com';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
  });

  tearDown(() {
    reset(authService);
  });

  blocTest(
    'email changed, '
    'should update email in state',
    build: () => ForgotPasswordCubit(),
    act: (cubit) => cubit.emailChanged(email),
    expect: () => [
      const ForgotPasswordState(
        status: CubitStatusComplete(),
        email: email,
      ),
    ],
  );

  blocTest(
    'submit, '
    'should call auth service method to send password reset email and should emit complete status with email submitted info',
    build: () => ForgotPasswordCubit(
      initialState: const ForgotPasswordState(
        status: CubitStatusInitial(),
        email: email,
      ),
    ),
    setUp: () => authService.mockSendPasswordResetEmail(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const ForgotPasswordState(
        status: CubitStatusLoading(),
        email: email,
      ),
      const ForgotPasswordState(
        status: CubitStatusComplete<ForgotPasswordCubitInfo>(
          info: ForgotPasswordCubitInfo.emailSubmitted,
        ),
        email: email,
      ),
    ],
    verify: (_) => verify(
      () => authService.sendPasswordResetEmail(email: email),
    ).called(1),
  );

  blocTest(
    'submit, '
    'auth exception with invalid email code, '
    'should emit error status with invalid email error',
    build: () => ForgotPasswordCubit(
      initialState: const ForgotPasswordState(
        status: CubitStatusInitial(),
        email: email,
      ),
    ),
    setUp: () => authService.mockSendPasswordResetEmail(
      throwable: const AuthException(
        code: AuthExceptionCode.invalidEmail,
      ),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const ForgotPasswordState(
        status: CubitStatusLoading(),
        email: email,
      ),
      const ForgotPasswordState(
        status: CubitStatusError<ForgotPasswordCubitError>(
          error: ForgotPasswordCubitError.invalidEmail,
        ),
        email: email,
      ),
    ],
    verify: (_) => verify(
      () => authService.sendPasswordResetEmail(email: email),
    ).called(1),
  );

  blocTest(
    'submit, '
    'auth exception with user not found code, '
    'should emit error status with user not found error',
    build: () => ForgotPasswordCubit(
      initialState: const ForgotPasswordState(
        status: CubitStatusInitial(),
        email: email,
      ),
    ),
    setUp: () => authService.mockSendPasswordResetEmail(
      throwable: const AuthException(
        code: AuthExceptionCode.userNotFound,
      ),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const ForgotPasswordState(
        status: CubitStatusLoading(),
        email: email,
      ),
      const ForgotPasswordState(
        status: CubitStatusError<ForgotPasswordCubitError>(
          error: ForgotPasswordCubitError.userNotFound,
        ),
        email: email,
      ),
    ],
    verify: (_) => verify(
      () => authService.sendPasswordResetEmail(email: email),
    ).called(1),
  );

  blocTest(
    'submit, '
    'network exception with request failed code, '
    'should emit network request failed status',
    build: () => ForgotPasswordCubit(
      initialState: const ForgotPasswordState(
        status: CubitStatusInitial(),
        email: email,
      ),
    ),
    setUp: () => authService.mockSendPasswordResetEmail(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const ForgotPasswordState(
        status: CubitStatusLoading(),
        email: email,
      ),
      const ForgotPasswordState(
        status: CubitStatusNoInternetConnection(),
        email: email,
      ),
    ],
    verify: (_) => verify(
      () => authService.sendPasswordResetEmail(email: email),
    ).called(1),
  );

  blocTest(
    'submit, '
    'unknown exception, '
    'should emit unknown error status and throw exception message',
    build: () => ForgotPasswordCubit(
      initialState: const ForgotPasswordState(
        status: CubitStatusInitial(),
        email: email,
      ),
    ),
    setUp: () => authService.mockSendPasswordResetEmail(
      throwable: const UnknownException(message: 'unknown exception message'),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const ForgotPasswordState(
        status: CubitStatusLoading(),
        email: email,
      ),
      const ForgotPasswordState(
        status: CubitStatusUnknownError(),
        email: email,
      ),
    ],
    errors: () => [
      const UnknownException(message: 'unknown exception message'),
    ],
    verify: (_) => verify(
      () => authService.sendPasswordResetEmail(email: email),
    ).called(1),
  );
}
