import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/auth_provider.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/bloc/reauthentication/reauthentication_bloc.dart';
import 'package:runnoter/domain/service/auth_service.dart';

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
    build: () => ReauthenticationBloc(),
    act: (bloc) => bloc.add(const ReauthenticationEventPasswordChanged(
      password: 'passwd1122',
    )),
    expect: () => [
      const ReauthenticationState(
        status: BlocStatusComplete(),
        password: 'passwd1122',
      )
    ],
  );

  blocTest(
    'use password, '
    'password is null, '
    'should do nothing',
    build: () => ReauthenticationBloc(),
    act: (bloc) => bloc.add(const ReauthenticationEventUsePassword()),
    expect: () => [],
  );

  blocTest(
    'use password, '
    'password is empty string, '
    'should do nothing',
    build: () => ReauthenticationBloc(
      state: const ReauthenticationState(
        status: BlocStatusComplete(),
        password: '',
      ),
    ),
    act: (bloc) => bloc.add(const ReauthenticationEventUsePassword()),
    expect: () => [],
  );

  blocTest(
    'use password, '
    'confirmed, '
    'should emit complete status with userConfirmed info',
    build: () => ReauthenticationBloc(
      state: const ReauthenticationState(
        status: BlocStatusComplete(),
        password: 'passwd',
      ),
    ),
    setUp: () => authService.mockReauthenticate(
      reauthenticationStatus: ReauthenticationStatus.confirmed,
    ),
    act: (bloc) => bloc.add(const ReauthenticationEventUsePassword()),
    expect: () => [
      const ReauthenticationState(
        status: BlocStatusLoading<ReauthenticationBlocLoadingInfo>(
          loadingInfo:
              ReauthenticationBlocLoadingInfo.passwordReauthenticationLoading,
        ),
        password: 'passwd',
      ),
      const ReauthenticationState(
        status: BlocStatusComplete<ReauthenticationBlocInfo>(
          info: ReauthenticationBlocInfo.userConfirmed,
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
    build: () => ReauthenticationBloc(
      state: const ReauthenticationState(
        status: BlocStatusComplete(),
        password: 'passwd',
      ),
    ),
    setUp: () => authService.mockReauthenticate(
      reauthenticationStatus: ReauthenticationStatus.cancelled,
    ),
    act: (bloc) => bloc.add(const ReauthenticationEventUsePassword()),
    expect: () => [
      const ReauthenticationState(
        status: BlocStatusLoading<ReauthenticationBlocLoadingInfo>(
          loadingInfo:
              ReauthenticationBlocLoadingInfo.passwordReauthenticationLoading,
        ),
        password: 'passwd',
      ),
      const ReauthenticationState(
        status: BlocStatusComplete<ReauthenticationBlocInfo>(),
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
    build: () => ReauthenticationBloc(
      state: const ReauthenticationState(
        status: BlocStatusComplete(),
        password: 'passwd',
      ),
    ),
    setUp: () => authService.mockReauthenticate(
      throwable: const AuthException(code: AuthExceptionCode.wrongPassword),
    ),
    act: (bloc) => bloc.add(const ReauthenticationEventUsePassword()),
    expect: () => [
      const ReauthenticationState(
        status: BlocStatusLoading<ReauthenticationBlocLoadingInfo>(
          loadingInfo:
              ReauthenticationBlocLoadingInfo.passwordReauthenticationLoading,
        ),
        password: 'passwd',
      ),
      const ReauthenticationState(
        status: BlocStatusError<ReauthenticationBlocError>(
          error: ReauthenticationBlocError.wrongPassword,
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
    build: () => ReauthenticationBloc(
      state: const ReauthenticationState(
        status: BlocStatusComplete(),
        password: 'passwd',
      ),
    ),
    setUp: () => authService.mockReauthenticate(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (bloc) => bloc.add(const ReauthenticationEventUsePassword()),
    expect: () => [
      const ReauthenticationState(
        status: BlocStatusLoading<ReauthenticationBlocLoadingInfo>(
          loadingInfo:
              ReauthenticationBlocLoadingInfo.passwordReauthenticationLoading,
        ),
        password: 'passwd',
      ),
      const ReauthenticationState(
        status: BlocStatusNoInternetConnection(),
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
    'confirmed'
    'should emit complete status with userConfirmed info',
    build: () => ReauthenticationBloc(),
    setUp: () => authService.mockReauthenticate(
      reauthenticationStatus: ReauthenticationStatus.confirmed,
    ),
    act: (bloc) => bloc.add(const ReauthenticationEventUseGoogle()),
    expect: () => [
      const ReauthenticationState(
        status: BlocStatusLoading<ReauthenticationBlocLoadingInfo>(
          loadingInfo:
              ReauthenticationBlocLoadingInfo.googleReauthenticationLoading,
        ),
      ),
      const ReauthenticationState(
        status: BlocStatusComplete<ReauthenticationBlocInfo>(
          info: ReauthenticationBlocInfo.userConfirmed,
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
    'cancelled'
    'should emit complete status without any info',
    build: () => ReauthenticationBloc(),
    setUp: () => authService.mockReauthenticate(
      reauthenticationStatus: ReauthenticationStatus.cancelled,
    ),
    act: (bloc) => bloc.add(const ReauthenticationEventUseGoogle()),
    expect: () => [
      const ReauthenticationState(
        status: BlocStatusLoading<ReauthenticationBlocLoadingInfo>(
          loadingInfo:
              ReauthenticationBlocLoadingInfo.googleReauthenticationLoading,
        ),
      ),
      const ReauthenticationState(
        status: BlocStatusComplete<ReauthenticationBlocInfo>(),
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
    'user mismatch, '
    'should emit error status with userMismatch error',
    build: () => ReauthenticationBloc(),
    setUp: () => authService.mockReauthenticate(
      reauthenticationStatus: ReauthenticationStatus.userMismatch,
    ),
    act: (bloc) => bloc.add(const ReauthenticationEventUseGoogle()),
    expect: () => [
      const ReauthenticationState(
        status: BlocStatusLoading<ReauthenticationBlocLoadingInfo>(
          loadingInfo:
              ReauthenticationBlocLoadingInfo.googleReauthenticationLoading,
        ),
      ),
      const ReauthenticationState(
        status: BlocStatusError<ReauthenticationBlocError>(
          error: ReauthenticationBlocError.userMismatch,
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
    build: () => ReauthenticationBloc(),
    setUp: () => authService.mockReauthenticate(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (bloc) => bloc.add(const ReauthenticationEventUseGoogle()),
    expect: () => [
      const ReauthenticationState(
        status: BlocStatusLoading<ReauthenticationBlocLoadingInfo>(
          loadingInfo:
              ReauthenticationBlocLoadingInfo.googleReauthenticationLoading,
        ),
      ),
      const ReauthenticationState(status: BlocStatusNoInternetConnection()),
    ],
    verify: (_) => verify(
      () => authService.reauthenticate(
        authProvider: const AuthProviderGoogle(),
      ),
    ).called(1),
  );

  blocTest(
    'use facebook, '
    'confirmed'
    'should emit complete status with userConfirmed info',
    build: () => ReauthenticationBloc(),
    setUp: () => authService.mockReauthenticate(
      reauthenticationStatus: ReauthenticationStatus.confirmed,
    ),
    act: (bloc) => bloc.add(const ReauthenticationEventUseFacebook()),
    expect: () => [
      const ReauthenticationState(
        status: BlocStatusLoading<ReauthenticationBlocLoadingInfo>(
          loadingInfo:
              ReauthenticationBlocLoadingInfo.facebookReauthenticationLoading,
        ),
      ),
      const ReauthenticationState(
        status: BlocStatusComplete<ReauthenticationBlocInfo>(
          info: ReauthenticationBlocInfo.userConfirmed,
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
    'cancelled'
    'should emit complete status without any info',
    build: () => ReauthenticationBloc(),
    setUp: () => authService.mockReauthenticate(
      reauthenticationStatus: ReauthenticationStatus.cancelled,
    ),
    act: (bloc) => bloc.add(const ReauthenticationEventUseFacebook()),
    expect: () => [
      const ReauthenticationState(
        status: BlocStatusLoading<ReauthenticationBlocLoadingInfo>(
          loadingInfo:
              ReauthenticationBlocLoadingInfo.facebookReauthenticationLoading,
        ),
      ),
      const ReauthenticationState(
        status: BlocStatusComplete<ReauthenticationBlocInfo>(),
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
    'user mismatch, '
    'should emit error status with userMismatch error',
    build: () => ReauthenticationBloc(),
    setUp: () => authService.mockReauthenticate(
      reauthenticationStatus: ReauthenticationStatus.userMismatch,
    ),
    act: (bloc) => bloc.add(const ReauthenticationEventUseFacebook()),
    expect: () => [
      const ReauthenticationState(
        status: BlocStatusLoading<ReauthenticationBlocLoadingInfo>(
          loadingInfo:
              ReauthenticationBlocLoadingInfo.facebookReauthenticationLoading,
        ),
      ),
      const ReauthenticationState(
        status: BlocStatusError<ReauthenticationBlocError>(
          error: ReauthenticationBlocError.userMismatch,
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
    build: () => ReauthenticationBloc(),
    setUp: () => authService.mockReauthenticate(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (bloc) => bloc.add(const ReauthenticationEventUseFacebook()),
    expect: () => [
      const ReauthenticationState(
        status: BlocStatusLoading<ReauthenticationBlocLoadingInfo>(
          loadingInfo:
              ReauthenticationBlocLoadingInfo.facebookReauthenticationLoading,
        ),
      ),
      const ReauthenticationState(status: BlocStatusNoInternetConnection()),
    ],
    verify: (_) => verify(
      () => authService.reauthenticate(
        authProvider: const AuthProviderFacebook(),
      ),
    ).called(1),
  );
}
