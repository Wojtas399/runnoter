import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../mock/domain/service/mock_auth_service.dart';

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
        status: BlocStatusComplete(),
        email: email,
      ),
    ],
  );

  blocTest(
    'submit, '
    'should call auth service method to send password reset email and should emit complete status with email submitted info',
    build: () => ForgotPasswordCubit(
      initialState: const ForgotPasswordState(
        status: BlocStatusInitial(),
        email: email,
      ),
    ),
    setUp: () => authService.mockSendPasswordResetEmail(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const ForgotPasswordState(
        status: BlocStatusLoading(),
        email: email,
      ),
      const ForgotPasswordState(
        status: BlocStatusComplete<ForgotPasswordCubitInfo>(
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
        status: BlocStatusInitial(),
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
        status: BlocStatusLoading(),
        email: email,
      ),
      const ForgotPasswordState(
        status: BlocStatusError<ForgotPasswordCubitError>(
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
        status: BlocStatusInitial(),
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
        status: BlocStatusLoading(),
        email: email,
      ),
      const ForgotPasswordState(
        status: BlocStatusError<ForgotPasswordCubitError>(
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
        status: BlocStatusInitial(),
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
        status: BlocStatusLoading(),
        email: email,
      ),
      const ForgotPasswordState(
        status: BlocStatusNoInternetConnection(),
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
        status: BlocStatusInitial(),
        email: email,
      ),
    ),
    setUp: () => authService.mockSendPasswordResetEmail(
      throwable: const UnknownException(message: 'unknown exception message'),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const ForgotPasswordState(
        status: BlocStatusLoading(),
        email: email,
      ),
      const ForgotPasswordState(
        status: BlocStatusUnknownError(),
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
