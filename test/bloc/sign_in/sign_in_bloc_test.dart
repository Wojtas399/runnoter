import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/model/bloc_status.dart';
import 'package:runnoter/screens/sign_in/bloc/sign_in_bloc.dart';

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

      blocTest(
        "email and password are not empty, should call method responsible for sign in user",
        build: () => createBloc(
          email: email,
          password: password,
        ),
        act: callEvent,
        verify: (_) {
          verify(
            () => auth.signIn(
              email: email,
              password: password,
            ),
          ).called(1);
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
