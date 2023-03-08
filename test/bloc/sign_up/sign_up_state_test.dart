import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/sign_up/bloc/sign_up_bloc.dart';

void main() {
  late SignUpState state;

  setUp(() {
    state = const SignUpState(
      status: BlocStatusInitial(),
      name: '',
      surname: '',
      email: '',
      password: '',
      passwordConfirmation: '',
    );
  });

  test(
    "is password confirmation valid, passwords aren't the same, should be false",
    () {
      const String password = 'password';
      const String passwordConfirmation = 'passw';

      state = state.copyWith(
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      expect(state.isPasswordConfirmationValid, false);
    },
  );

  test(
    "is password confirmation valid, passwords are the same, should be true",
    () {
      const String password = 'password';
      const String passwordConfirmation = 'password';

      state = state.copyWith(
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      expect(state.isPasswordConfirmationValid, true);
    },
  );

  test(
    "copy with status",
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    "copy with name",
    () {
      const String expectedName = 'Jack';

      state = state.copyWith(name: expectedName);
      final state2 = state.copyWith();

      expect(state.name, expectedName);
      expect(state2.name, expectedName);
    },
  );

  test(
    "copy with surname",
    () {
      const String expectedSurname = 'Sparrowsky';

      state = state.copyWith(surname: expectedSurname);
      final state2 = state.copyWith();

      expect(state.surname, expectedSurname);
      expect(state2.surname, expectedSurname);
    },
  );

  test(
    "copy with email",
    () {
      const String expectedEmail = 'jack@example.com';

      state = state.copyWith(email: expectedEmail);
      final state2 = state.copyWith();

      expect(state.email, expectedEmail);
      expect(state2.email, expectedEmail);
    },
  );

  test(
    "copy with password",
    () {
      const String expectedPassword = 'password123';

      state = state.copyWith(password: expectedPassword);
      final state2 = state.copyWith();

      expect(state.password, expectedPassword);
      expect(state2.password, expectedPassword);
    },
  );

  test(
    "copy with password confirmation",
    () {
      const String expectedPasswordConfirmation = 'password321';

      state = state.copyWith(
        passwordConfirmation: expectedPasswordConfirmation,
      );
      final state2 = state.copyWith();

      expect(state.passwordConfirmation, expectedPasswordConfirmation);
      expect(state2.passwordConfirmation, expectedPasswordConfirmation);
    },
  );
}
