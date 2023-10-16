import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/interface/service/auth_service.dart';
import 'package:runnoter/data/model/custom_exception.dart';
import 'package:runnoter/ui/cubit/reauthentication/reauthentication_cubit.dart';
import 'package:runnoter/ui/model/cubit_status.dart';

import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
  });

  tearDown(() {
    reset(authService);
  });

  blocTest(
    'password changed, '
    'should update password in state',
    build: () => ReauthenticationCubit(),
    act: (cubit) => cubit.passwordChanged('passwd1122'),
    expect: () => [
      const ReauthenticationState(
        status: CubitStatusComplete(),
        password: 'passwd1122',
      )
    ],
  );

  blocTest(
    'use password, '
    'password is null, '
    'should do nothing',
    build: () => ReauthenticationCubit(),
    act: (cubit) => cubit.usePassword(),
    expect: () => [],
  );

  blocTest(
    'use password, '
    'password is empty string, '
    'should do nothing',
    build: () => ReauthenticationCubit(
      initialState: const ReauthenticationState(
        status: CubitStatusComplete(),
        password: '',
      ),
    ),
    act: (cubit) => cubit.usePassword(),
    expect: () => [],
  );

  blocTest(
    'use password, '
    'confirmed, '
    'should emit complete status with userConfirmed info',
    build: () => ReauthenticationCubit(
      initialState: const ReauthenticationState(
        status: CubitStatusComplete(),
        password: 'passwd',
      ),
    ),
    setUp: () => authService.mockReauthenticate(
      reauthenticationStatus: ReauthenticationStatus.confirmed,
    ),
    act: (cubit) => cubit.usePassword(),
    expect: () => [
      const ReauthenticationState(
        status: CubitStatusLoading<ReauthenticationCubitLoadingInfo>(
          loadingInfo:
              ReauthenticationCubitLoadingInfo.passwordReauthenticationLoading,
        ),
        password: 'passwd',
      ),
      const ReauthenticationState(
        status: CubitStatusComplete<ReauthenticationCubitInfo>(
          info: ReauthenticationCubitInfo.userConfirmed,
        ),
        password: 'passwd',
      ),
    ],
    verify: (_) => verify(
      () => authService.reauthenticate(
        authProvider: const AuthProviderPassword(password: 'passwd'),
      ),
    ).called(1),
  );

  blocTest(
    'use password, '
    'cancelled, '
    'should emit complete status without any info',
    build: () => ReauthenticationCubit(
      initialState: const ReauthenticationState(
        status: CubitStatusComplete(),
        password: 'passwd',
      ),
    ),
    setUp: () => authService.mockReauthenticate(
      reauthenticationStatus: ReauthenticationStatus.cancelled,
    ),
    act: (cubit) => cubit.usePassword(),
    expect: () => [
      const ReauthenticationState(
        status: CubitStatusLoading<ReauthenticationCubitLoadingInfo>(
          loadingInfo:
              ReauthenticationCubitLoadingInfo.passwordReauthenticationLoading,
        ),
        password: 'passwd',
      ),
      const ReauthenticationState(
        status: CubitStatusComplete(),
        password: 'passwd',
      ),
    ],
    verify: (_) => verify(
      () => authService.reauthenticate(
        authProvider: const AuthProviderPassword(password: 'passwd'),
      ),
    ).called(1),
  );

  blocTest(
    'use password, '
    'auth exception with wrongPassword code, '
    'should emit error status with wrongPassword error',
    build: () => ReauthenticationCubit(
      initialState: const ReauthenticationState(
        status: CubitStatusComplete(),
        password: 'passwd',
      ),
    ),
    setUp: () => authService.mockReauthenticate(
      throwable: const AuthException(code: AuthExceptionCode.wrongPassword),
    ),
    act: (cubit) => cubit.usePassword(),
    expect: () => [
      const ReauthenticationState(
        status: CubitStatusLoading<ReauthenticationCubitLoadingInfo>(
          loadingInfo:
              ReauthenticationCubitLoadingInfo.passwordReauthenticationLoading,
        ),
        password: 'passwd',
      ),
      const ReauthenticationState(
        status: CubitStatusError<ReauthenticationCubitError>(
          error: ReauthenticationCubitError.wrongPassword,
        ),
        password: 'passwd',
      ),
    ],
    verify: (_) => verify(
      () => authService.reauthenticate(
        authProvider: const AuthProviderPassword(password: 'passwd'),
      ),
    ).called(1),
  );

  blocTest(
    'use password, '
    'network exception with requestFailed code, '
    'should emit no internet connection status',
    build: () => ReauthenticationCubit(
      initialState: const ReauthenticationState(
        status: CubitStatusComplete(),
        password: 'passwd',
      ),
    ),
    setUp: () => authService.mockReauthenticate(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (cubit) => cubit.usePassword(),
    expect: () => [
      const ReauthenticationState(
        status: CubitStatusLoading<ReauthenticationCubitLoadingInfo>(
          loadingInfo:
              ReauthenticationCubitLoadingInfo.passwordReauthenticationLoading,
        ),
        password: 'passwd',
      ),
      const ReauthenticationState(
        status: CubitStatusNoInternetConnection(),
        password: 'passwd',
      ),
    ],
    verify: (_) => verify(
      () => authService.reauthenticate(
        authProvider: const AuthProviderPassword(password: 'passwd'),
      ),
    ).called(1),
  );

  blocTest(
    'use google, '
    'confirmed, '
    'should emit complete status with userConfirmed info',
    build: () => ReauthenticationCubit(),
    setUp: () => authService.mockReauthenticate(
      reauthenticationStatus: ReauthenticationStatus.confirmed,
    ),
    act: (cubit) => cubit.useGoogle(),
    expect: () => [
      const ReauthenticationState(
        status: CubitStatusLoading<ReauthenticationCubitLoadingInfo>(
          loadingInfo:
              ReauthenticationCubitLoadingInfo.googleReauthenticationLoading,
        ),
      ),
      const ReauthenticationState(
        status: CubitStatusComplete<ReauthenticationCubitInfo>(
          info: ReauthenticationCubitInfo.userConfirmed,
        ),
      ),
    ],
    verify: (_) => verify(
      () => authService.reauthenticate(
        authProvider: const AuthProviderGoogle(),
      ),
    ).called(1),
  );

  blocTest(
    'use google, '
    'cancelled, '
    'should emit complete status without any info',
    build: () => ReauthenticationCubit(),
    setUp: () => authService.mockReauthenticate(
      reauthenticationStatus: ReauthenticationStatus.cancelled,
    ),
    act: (cubit) => cubit.useGoogle(),
    expect: () => [
      const ReauthenticationState(
        status: CubitStatusLoading<ReauthenticationCubitLoadingInfo>(
          loadingInfo:
              ReauthenticationCubitLoadingInfo.googleReauthenticationLoading,
        ),
      ),
      const ReauthenticationState(status: CubitStatusComplete()),
    ],
    verify: (_) => verify(
      () => authService.reauthenticate(
        authProvider: const AuthProviderGoogle(),
      ),
    ).called(1),
  );

  blocTest(
    'use google, '
    'user mismatch, '
    'should emit error status with userMismatch error',
    build: () => ReauthenticationCubit(),
    setUp: () => authService.mockReauthenticate(
      reauthenticationStatus: ReauthenticationStatus.userMismatch,
    ),
    act: (cubit) => cubit.useGoogle(),
    expect: () => [
      const ReauthenticationState(
        status: CubitStatusLoading<ReauthenticationCubitLoadingInfo>(
          loadingInfo:
              ReauthenticationCubitLoadingInfo.googleReauthenticationLoading,
        ),
      ),
      const ReauthenticationState(
        status: CubitStatusError<ReauthenticationCubitError>(
          error: ReauthenticationCubitError.userMismatch,
        ),
      ),
    ],
    verify: (_) => verify(
      () => authService.reauthenticate(
        authProvider: const AuthProviderGoogle(),
      ),
    ).called(1),
  );

  blocTest(
    'use google, '
    'network exception with requestFailed code, '
    'should emit no internet connection status',
    build: () => ReauthenticationCubit(),
    setUp: () => authService.mockReauthenticate(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (cubit) => cubit.useGoogle(),
    expect: () => [
      const ReauthenticationState(
        status: CubitStatusLoading<ReauthenticationCubitLoadingInfo>(
          loadingInfo:
              ReauthenticationCubitLoadingInfo.googleReauthenticationLoading,
        ),
      ),
      const ReauthenticationState(status: CubitStatusNoInternetConnection()),
    ],
    verify: (_) => verify(
      () => authService.reauthenticate(
        authProvider: const AuthProviderGoogle(),
      ),
    ).called(1),
  );

  blocTest(
    'use facebook, '
    'confirmed, '
    'should emit complete status with userConfirmed info',
    build: () => ReauthenticationCubit(),
    setUp: () => authService.mockReauthenticate(
      reauthenticationStatus: ReauthenticationStatus.confirmed,
    ),
    act: (cubit) => cubit.useFacebook(),
    expect: () => [
      const ReauthenticationState(
        status: CubitStatusLoading<ReauthenticationCubitLoadingInfo>(
          loadingInfo:
              ReauthenticationCubitLoadingInfo.facebookReauthenticationLoading,
        ),
      ),
      const ReauthenticationState(
        status: CubitStatusComplete<ReauthenticationCubitInfo>(
          info: ReauthenticationCubitInfo.userConfirmed,
        ),
      ),
    ],
    verify: (_) => verify(
      () => authService.reauthenticate(
        authProvider: const AuthProviderFacebook(),
      ),
    ).called(1),
  );

  blocTest(
    'use facebook, '
    'cancelled, '
    'should emit complete status without any info',
    build: () => ReauthenticationCubit(),
    setUp: () => authService.mockReauthenticate(
      reauthenticationStatus: ReauthenticationStatus.cancelled,
    ),
    act: (cubit) => cubit.useFacebook(),
    expect: () => [
      const ReauthenticationState(
        status: CubitStatusLoading<ReauthenticationCubitLoadingInfo>(
          loadingInfo:
              ReauthenticationCubitLoadingInfo.facebookReauthenticationLoading,
        ),
      ),
      const ReauthenticationState(status: CubitStatusComplete()),
    ],
    verify: (_) => verify(
      () => authService.reauthenticate(
        authProvider: const AuthProviderFacebook(),
      ),
    ).called(1),
  );

  blocTest(
    'use facebook, '
    'user mismatch, '
    'should emit error status with userMismatch error',
    build: () => ReauthenticationCubit(),
    setUp: () => authService.mockReauthenticate(
      reauthenticationStatus: ReauthenticationStatus.userMismatch,
    ),
    act: (cubit) => cubit.useFacebook(),
    expect: () => [
      const ReauthenticationState(
        status: CubitStatusLoading<ReauthenticationCubitLoadingInfo>(
          loadingInfo:
              ReauthenticationCubitLoadingInfo.facebookReauthenticationLoading,
        ),
      ),
      const ReauthenticationState(
        status: CubitStatusError<ReauthenticationCubitError>(
          error: ReauthenticationCubitError.userMismatch,
        ),
      ),
    ],
    verify: (_) => verify(
      () => authService.reauthenticate(
        authProvider: const AuthProviderFacebook(),
      ),
    ).called(1),
  );

  blocTest(
    'use facebook, '
    'network exception with requestFailed code, '
    'should emit no internet connection status',
    build: () => ReauthenticationCubit(),
    setUp: () => authService.mockReauthenticate(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (cubit) => cubit.useFacebook(),
    expect: () => [
      const ReauthenticationState(
        status: CubitStatusLoading<ReauthenticationCubitLoadingInfo>(
          loadingInfo:
              ReauthenticationCubitLoadingInfo.facebookReauthenticationLoading,
        ),
      ),
      const ReauthenticationState(status: CubitStatusNoInternetConnection()),
    ],
    verify: (_) => verify(
      () => authService.reauthenticate(
        authProvider: const AuthProviderFacebook(),
      ),
    ).called(1),
  );
}
