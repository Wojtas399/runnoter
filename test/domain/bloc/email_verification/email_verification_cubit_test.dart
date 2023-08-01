import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/bloc/email_verification/email_verification_cubit.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  const String loggedUserEmail = 'email@example.com';

  setUpAll(() {
    GetIt.I.registerLazySingleton<AuthService>(() => authService);
  });

  tearDown(() {
    reset(authService);
  });

  blocTest(
    'initialize, '
    'should load and emit logged user email',
    build: () => EmailVerificationCubit(),
    setUp: () => authService.mockGetLoggedUserEmail(userEmail: loggedUserEmail),
    act: (cubit) => cubit.initialize(),
    expect: () => [loggedUserEmail],
    verify: (_) => verify(() => authService.loggedUserEmail$).called(1),
  );

  blocTest(
    'resend email verification, '
    "should call auth service's method to send email verification",
    build: () => EmailVerificationCubit(),
    setUp: () => authService.mockSendEmailVerification(),
    act: (cubit) => cubit.resendEmailVerification(),
    expect: () => [],
    verify: (_) => verify(authService.sendEmailVerification).called(1),
  );
}
