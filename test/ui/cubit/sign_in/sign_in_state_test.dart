import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/ui/cubit/sign_in/sign_in_cubit.dart';
import 'package:runnoter/ui/model/cubit_status.dart';

void main() {
  late SignInState state;

  setUp(() {
    state = const SignInState(
      status: CubitStatusInitial(),
      email: '',
      password: '',
    );
  });

  test(
    'canSubmit, email is empty, should be false',
    () {
      state = state.copyWith(
        password: 'password',
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'canSubmit, password is empty, should be false',
    () {
      state = state.copyWith(
        email: 'email@example.com',
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    "canSubmit, email and password aren't empty, should be true",
    () {
      state = state.copyWith(
        email: 'email@example.com',
        password: 'password',
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'copy with status',
    () {
      const expectedStatus = CubitStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const CubitStatusComplete());
    },
  );

  test(
    'copy with email',
    () {
      const expectedEmail = 'email@example.com';

      state = state.copyWith(email: expectedEmail);
      final state2 = state.copyWith();

      expect(state.email, expectedEmail);
      expect(state2.email, expectedEmail);
    },
  );

  test(
    'copy with password',
    () {
      const expectedPassword = 'password123';

      state = state.copyWith(password: expectedPassword);
      final state2 = state.copyWith();

      expect(state.password, expectedPassword);
      expect(state2.password, expectedPassword);
    },
  );
}
