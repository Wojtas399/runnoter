import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/model/auth_exception.dart';
import 'package:runnoter/model/bloc_status.dart';
import 'package:runnoter/ui/screen/sign_in/bloc/sign_in_bloc.dart';

import '../../mock/mock_auth.dart';

void main() {
  final auth = MockAuth();

  SignInBloc createBloc({
    final String? email,
    final String? password,
  }) {
    return SignInBloc(
      auth: auth,
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
    reset(auth);
  });

  blocTest(
    "email changed, should update email in state",
    build: () => createBloc(),
    act: (SignInBloc bloc) {
      bloc.add(
        const SignInEventEmailChanged(
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

  blocTest(
    "password changed, should update password in state",
    build: () => createBloc(),
    act: (SignInBloc bloc) {
      bloc.add(
        const SignInEventPasswordChanged(
          password: 'password 123',
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        password: 'password 123',
      ),
    ],
  );

  group(
    "submit",
    () {
      const String email = 'email@example.com';
      const String password = 'password123';

      void callEvent(SignInBloc bloc) {
        bloc.add(
          const SignInEventSubmit(),
        );
      }

      setUp(() {
        auth.mockSignIn();
      });

      group(
        "email and password are not empty, should call method responsible for signing in user",
        () {
          tearDown(() {
            verify(
              () => auth.signIn(
                email: email,
                password: password,
              ),
            ).called(1);
          });

          blocTest(
            "method doesn't throw error, should emit complete status",
            build: () => createBloc(
              email: email,
              password: password,
            ),
            act: callEvent,
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
          );

          blocTest(
            "method throws auth exception with invalid email code, should emit appropriate error status",
            build: () => createBloc(
              email: email,
              password: password,
            ),
            setUp: () {
              auth.mockSignIn(
                throwable: const AuthException(
                  code: AuthExceptionCode.invalidEmail,
                ),
              );
            },
            act: callEvent,
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
          );

          blocTest(
            "method throws auth exception with user not found code, should emit appropriate error status",
            build: () => createBloc(
              email: email,
              password: password,
            ),
            setUp: () {
              auth.mockSignIn(
                throwable: const AuthException(
                  code: AuthExceptionCode.userNotFound,
                ),
              );
            },
            act: callEvent,
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
          );

          blocTest(
            "method throws auth exception with wrong password code, should emit appropriate error status",
            build: () => createBloc(
              email: email,
              password: password,
            ),
            setUp: () {
              auth.mockSignIn(
                throwable: const AuthException(
                  code: AuthExceptionCode.wrongPassword,
                ),
              );
            },
            act: callEvent,
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
          );
        },
      );

      blocTest(
        "email is empty, shouldn't call method responsible for sign in user",
        build: () => createBloc(
          password: password,
        ),
        act: callEvent,
        verify: (_) {
          verifyNever(
            () => auth.signIn(
              email: any(named: 'email'),
              password: password,
            ),
          );
        },
      );

      blocTest(
        "password is empty, shouldn't call method responsible for sign in user",
        build: () => createBloc(
          email: email,
        ),
        act: callEvent,
        verify: (_) {
          verifyNever(
            () => auth.signIn(
              email: email,
              password: any(named: 'password'),
            ),
          );
        },
      );
    },
  );
}
