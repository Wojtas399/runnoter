import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/auth_exception.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/forgot_password/forgot_password_bloc.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/presentation/service/mock_connectivity_service.dart';

void main() {
  final authService = MockAuthService();
  final connectivityService = MockConnectivityService();
  const String email = 'email@example.com';

  ForgotPasswordBloc createBloc({
    String email = '',
  }) {
    return ForgotPasswordBloc(
      authService: authService,
      connectivityService: connectivityService,
      email: email,
    );
  }

  ForgotPasswordState createState({
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
  }) {
    return ForgotPasswordState(
      status: status,
      email: email,
    );
  }

  blocTest(
    'email changed, '
    'should update email in state',
    build: () => createBloc(),
    act: (ForgotPasswordBloc bloc) {
      bloc.add(
        const ForgotPasswordEventEmailChanged(
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
    'submit, '
    'should call auth service method to send password reset email and should emit complete status with email submitted info',
    build: () => createBloc(
      email: email,
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(
        hasConnection: true,
      );
      authService.mockSendPasswordResetEmail();
    },
    act: (ForgotPasswordBloc bloc) {
      bloc.add(
        const ForgotPasswordEventSubmit(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        email: email,
      ),
      createState(
        status: const BlocStatusComplete<ForgotPasswordBlocInfo>(
          info: ForgotPasswordBlocInfo.emailSubmitted,
        ),
        email: email,
      ),
    ],
    verify: (_) {
      verify(
        () => connectivityService.hasDeviceInternetConnection(),
      ).called(1);
      verify(
        () => authService.sendPasswordResetEmail(
          email: email,
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'device does not have internet connection, '
    'should emit no internet connection status',
    build: () => createBloc(
      email: email,
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(
        hasConnection: false,
      );
    },
    act: (ForgotPasswordBloc bloc) {
      bloc.add(
        const ForgotPasswordEventSubmit(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        email: email,
      ),
      createState(
        status: const BlocStatusNoInternetConnection(),
        email: email,
      ),
    ],
    verify: (_) {
      verify(
        () => connectivityService.hasDeviceInternetConnection(),
      ).called(1);
      verifyNever(
        () => authService.sendPasswordResetEmail(
          email: any(named: 'email'),
        ),
      );
    },
  );

  blocTest(
    'submit, '
    'invalid email auth exception, '
    'should emit error status with invalid email error',
    build: () => createBloc(
      email: email,
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(
        hasConnection: true,
      );
      authService.mockSendPasswordResetEmail(
        throwable: AuthException.invalidEmail,
      );
    },
    act: (ForgotPasswordBloc bloc) {
      bloc.add(
        const ForgotPasswordEventSubmit(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        email: email,
      ),
      createState(
        status: const BlocStatusError<ForgotPasswordBlocError>(
          error: ForgotPasswordBlocError.invalidEmail,
        ),
        email: email,
      ),
    ],
    verify: (_) {
      verify(
        () => connectivityService.hasDeviceInternetConnection(),
      ).called(1);
      verify(
        () => authService.sendPasswordResetEmail(
          email: email,
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'user not found auth exception, '
    'should emit error status with user not found error',
    build: () => createBloc(
      email: email,
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(
        hasConnection: true,
      );
      authService.mockSendPasswordResetEmail(
        throwable: AuthException.userNotFound,
      );
    },
    act: (ForgotPasswordBloc bloc) {
      bloc.add(
        const ForgotPasswordEventSubmit(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        email: email,
      ),
      createState(
        status: const BlocStatusError<ForgotPasswordBlocError>(
          error: ForgotPasswordBlocError.userNotFound,
        ),
        email: email,
      ),
    ],
    verify: (_) {
      verify(
        () => connectivityService.hasDeviceInternetConnection(),
      ).called(1);
      verify(
        () => authService.sendPasswordResetEmail(
          email: email,
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'unknown exception, '
    'should emit unknown error status and should rethrow error',
    build: () => createBloc(
      email: email,
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(
        hasConnection: true,
      );
      authService.mockSendPasswordResetEmail(
        throwable: 'Unknown exception...',
      );
    },
    act: (ForgotPasswordBloc bloc) {
      bloc.add(
        const ForgotPasswordEventSubmit(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        email: email,
      ),
      createState(
        status: const BlocStatusUnknownError(),
        email: email,
      ),
    ],
    errors: () => [
      'Unknown exception...',
    ],
    verify: (_) {
      verify(
        () => connectivityService.hasDeviceInternetConnection(),
      ).called(1);
      verify(
        () => authService.sendPasswordResetEmail(
          email: email,
        ),
      ).called(1);
    },
  );
}
