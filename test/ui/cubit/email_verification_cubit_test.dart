import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/interface/service/auth_service.dart';
import 'package:runnoter/data/model/custom_exception.dart';
import 'package:runnoter/ui/cubit/email_verification_cubit.dart';

import '../../mock/data/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  const String loggedUserEmail = 'email@example.com';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
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
    expect: () => [
      const EmailVerificationStateComplete(email: loggedUserEmail),
    ],
    verify: (_) => verify(() => authService.loggedUserEmail$).called(1),
  );

  blocTest(
    'resend email verification, '
    'loading state, '
    'should do nothing',
    build: () => EmailVerificationCubit(
      state: const EmailVerificationStateLoading(),
    ),
    act: (cubit) => cubit.resendEmailVerification(),
    expect: () => [],
  );

  blocTest(
    'resend email verification, '
    "should call auth service's method to send email verification",
    build: () => EmailVerificationCubit(
      state: const EmailVerificationStateComplete(email: loggedUserEmail),
    ),
    setUp: () => authService.mockSendEmailVerification(),
    act: (cubit) => cubit.resendEmailVerification(),
    expect: () => [
      const EmailVerificationStateLoading(email: loggedUserEmail),
      const EmailVerificationStateComplete(email: loggedUserEmail),
    ],
    verify: (_) => verify(authService.sendEmailVerification).called(1),
  );

  blocTest(
    'resend email verification, '
    'network exception with tooManyRequests code, '
    'should emit tooManyRequests state',
    build: () => EmailVerificationCubit(
      state: const EmailVerificationStateComplete(email: loggedUserEmail),
    ),
    setUp: () => authService.mockSendEmailVerification(
      throwable: const NetworkException(
        code: NetworkExceptionCode.tooManyRequests,
      ),
    ),
    act: (cubit) => cubit.resendEmailVerification(),
    expect: () => [
      const EmailVerificationStateLoading(email: loggedUserEmail),
      const EmailVerificationStateTooManyRequests(email: loggedUserEmail),
    ],
    verify: (_) => verify(authService.sendEmailVerification).called(1),
  );
}
