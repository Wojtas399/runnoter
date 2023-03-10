import 'package:bloc_test/bloc_test.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/sign_up/bloc/sign_up_bloc.dart';

void main() {
  SignUpBloc createBloc() {
    return SignUpBloc();
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
}
