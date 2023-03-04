import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/model/bloc_status.dart';
import 'package:runnoter/screens/sign_in/bloc/sign_in_bloc.dart';

void main() {
  late SignInState state;

  setUp(() {
    state = const SignInState(
      status: BlocStatusInitial(),
      email: '',
      password: '',
    );
  });

  test(
    "is button disabled, email is empty, should be true",
    () {
      state = state.copyWith(
        password: 'password',
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    "is button disabled, password is empty, should be true",
    () {
      state = state.copyWith(
        email: 'email@example.com',
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    "is button disabled, email and password aren't empty, should be false",
    () {
      state = state.copyWith(
        email: 'email@example.com',
        password: 'password',
      );

      expect(state.isButtonDisabled, false);
    },
  );

  test(
    "copy with status",
    () {
      const expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    "copy with email",
    () {
      const expectedEmail = 'email@example.com';

      state = state.copyWith(email: expectedEmail);
      final state2 = state.copyWith();

      expect(state.email, expectedEmail);
      expect(state2.email, expectedEmail);
    },
  );

  test(
    "copy with password",
    () {
      const expectedPassword = 'password123';

      state = state.copyWith(password: expectedPassword);
      final state2 = state.copyWith();

      expect(state.password, expectedPassword);
      expect(state2.password, expectedPassword);
    },
  );
}
