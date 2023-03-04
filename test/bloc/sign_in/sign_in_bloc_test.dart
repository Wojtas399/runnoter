import 'package:bloc_test/bloc_test.dart';
import 'package:runnoter/model/bloc_status.dart';
import 'package:runnoter/screens/sign_in/bloc/sign_in_bloc.dart';

void main() {
  SignInBloc createBloc() {
    return SignInBloc();
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
}
