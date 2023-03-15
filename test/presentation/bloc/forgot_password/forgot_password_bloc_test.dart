import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/auth_exception.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:runnoter/presentation/screen/forgot_password/bloc/forgot_password_event.dart';
import 'package:runnoter/presentation/screen/forgot_password/bloc/forgot_password_state.dart';

import '../../../mock/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();

  ForgotPasswordBloc createBloc({
    String email = '',
  }) {
    return ForgotPasswordBloc(
      authService: authService,
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
    'email changed, should update email in state',
    build: () => createBloc(),
    act: (ForgotPasswordBloc bloc) {
      bloc.add(
        const ForgotPasswordEventEmailChanged(
          email: 'email@example.com',
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        email: 'email@example.com',
      ),
    ],
  );

  group(
    'submit',
    () {
      const String email = 'email@example.com';

      void eventCall(ForgotPasswordBloc bloc) {
        bloc.add(
          const ForgotPasswordEventSubmit(),
        );
      }

      tearDown(() {
        verify(
          () => authService.sendPasswordResetEmail(
            email: email,
          ),
        ).called(1);
      });

      blocTest(
        'should call method responsible for sending password reset email',
        build: () => createBloc(
          email: email,
        ),
        setUp: () {
          authService.mockSendPasswordResetEmail();
        },
        act: eventCall,
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            email: email,
          ),
          createState(
            status: const BlocStatusComplete<ForgotPasswordInfo>(
              info: ForgotPasswordInfo.emailSubmitted,
            ),
            email: email,
          ),
        ],
      );

      blocTest(
        'invalid email auth exception, should emit error status with invalid email type',
        build: () => createBloc(
          email: email,
        ),
        setUp: () {
          authService.mockSendPasswordResetEmail(
            throwable: AuthException.invalidEmail,
          );
        },
        act: eventCall,
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            email: email,
          ),
          createState(
            status: const BlocStatusError<ForgotPasswordError>(
              error: ForgotPasswordError.invalidEmail,
            ),
            email: email,
          ),
        ],
      );

      blocTest(
        'user not found auth exception, should emit error status with user not found type',
        build: () => createBloc(
          email: email,
        ),
        setUp: () {
          authService.mockSendPasswordResetEmail(
            throwable: AuthException.userNotFound,
          );
        },
        act: eventCall,
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            email: email,
          ),
          createState(
            status: const BlocStatusError<ForgotPasswordError>(
              error: ForgotPasswordError.userNotFound,
            ),
            email: email,
          ),
        ],
      );
    },
  );
}
