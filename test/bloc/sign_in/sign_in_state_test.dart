import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/model/bloc_status.dart';
import 'package:runnoter/screens/sign_in/bloc/sign_in_bloc.dart';

void main() {
  late SignInState state;

  setUp(() {
    state = const SignInState(
      status: BlocStatusInitial(),
    );
  });

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
