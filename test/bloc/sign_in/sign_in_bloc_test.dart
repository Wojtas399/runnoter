import 'package:bloc_test/bloc_test.dart';
import 'package:runnoter/model/bloc_status.dart';
import 'package:runnoter/screens/sign_in/bloc/sign_in_bloc.dart';

void main() {
  SignInBloc createBloc() {
    return SignInBloc();
  }

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
      const SignInState(
        status: BlocStatusComplete(),
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
      const SignInState(
        status: BlocStatusComplete(),
        password: 'password 123',
      ),
    ],
  );
}
