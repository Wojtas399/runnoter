import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/auth_exception.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/sign_up/bloc/sign_up_bloc.dart';

import '../../mock/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();

  SignUpBloc createBloc({
    String name = '',
    String surname = '',
    String email = '',
    String password = '',
  }) {
    return SignUpBloc(
      authService: authService,
      name: name,
      surname: surname,
      email: email,
      password: password,
    );
  }

  SignUpState createState({
    BlocStatus status = const BlocStatusInitial(),
    String name = '',
    String surname = '',
    String email = '',
    String password = '',
    String passwordConfirmation = '',
  }) {
    return SignUpState(
      status: status,
      name: name,
      surname: surname,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

  blocTest(
    "name changed, should update username in state",
    build: () => createBloc(),
    act: (SignUpBloc bloc) {
      bloc.add(
        const SignUpEventNameChanged(name: 'Jack'),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        name: 'Jack',
      ),
    ],
  );

  blocTest(
    "surname changed, should update surname in state",
    build: () => createBloc(),
    act: (SignUpBloc bloc) {
      bloc.add(
        const SignUpEventSurnameChanged(surname: 'Grealishowsky'),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        surname: 'Grealishowsky',
      ),
    ],
  );

  blocTest(
    "email changed, should update email in state",
    build: () => createBloc(),
    act: (SignUpBloc bloc) {
      bloc.add(
        const SignUpEventEmailChanged(email: 'jack@example.com'),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        email: 'jack@example.com',
      ),
    ],
  );

  blocTest(
    "password changed, should update password in state",
    build: () => createBloc(),
    act: (SignUpBloc bloc) {
      bloc.add(
        const SignUpEventPasswordChanged(password: 'password123'),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        password: 'password123',
      ),
    ],
  );

  blocTest(
    "password confirmation changed, should update password confirmation in state",
    build: () => createBloc(),
    act: (SignUpBloc bloc) {
      bloc.add(
        const SignUpEventPasswordConfirmationChanged(
          passwordConfirmation: 'passwordConfirmation123',
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        passwordConfirmation: 'passwordConfirmation123',
      ),
    ],
  );

  group(
    "sign up",
    () {
      const String name = 'Jack';
      const String surname = 'Gadovsky';
      const String email = 'email@example.com';
      const String password = 'Password1';
      final SignUpState state = createState(
        name: name,
        surname: surname,
        email: email,
        password: password,
      );

      void callEvent(SignUpBloc bloc) {
        bloc.add(
          const SignUpEventSubmit(),
        );
      }

      tearDown(() {
        verify(
          () => authService.signUp(
            name: name,
            surname: surname,
            email: email,
            password: password,
          ),
        ).called(1);
      });

      blocTest(
        "should call method responsible for signing up",
        build: () => createBloc(
          name: name,
          surname: surname,
          email: email,
          password: password,
        ),
        setUp: () {
          authService.mockSignUp();
        },
        act: callEvent,
        expect: () => [
          state.copyWith(
            status: const BlocStatusLoading(),
          ),
          state.copyWith(
            status: const BlocStatusComplete<SignUpInfo>(
              info: SignUpInfo.signedUp,
            ),
          ),
        ],
      );

      blocTest(
        "sign up method throws exception with email already in use code, should emit error state with email already in use code",
        build: () => createBloc(
          name: name,
          surname: surname,
          email: email,
          password: password,
        ),
        setUp: () {
          authService.mockSignUp(
            throwable: const AuthException(
              code: AuthExceptionCode.emailAlreadyInUse,
            ),
          );
        },
        act: callEvent,
        expect: () => [
          state.copyWith(
            status: const BlocStatusLoading(),
          ),
          state.copyWith(
            status: const BlocStatusError<SignUpError>(
              error: SignUpError.emailAlreadyTaken,
            ),
          ),
        ],
      );

      blocTest(
        "sign up method throws unknown error, should rethrow",
        build: () => createBloc(
          name: name,
          surname: surname,
          email: email,
          password: password,
        ),
        setUp: () {
          authService.mockSignUp(
            throwable: 'Unknown error',
          );
        },
        act: callEvent,
        expect: () => [
          state.copyWith(
            status: const BlocStatusLoading(),
          ),
        ],
        errors: () => [
          'Unknown error',
        ],
      );
    },
  );
}
