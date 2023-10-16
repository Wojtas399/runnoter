import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/ui/cubit/forgot_password/forgot_password_cubit.dart';

void main() {
  late ForgotPasswordState state;

  setUp(() {
    state = const ForgotPasswordState(status: CubitStatusInitial());
  });

  test(
    'is submit button disabled, email is empty, should be true',
    () {
      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, email is not empty, should be false',
    () {
      const String email = 'email@example.com';

      state = state.copyWith(
        email: email,
      );

      expect(state.isSubmitButtonDisabled, false);
    },
  );

  test(
    'copy with status',
    () {
      const CubitStatus expectedStatus = CubitStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const CubitStatusComplete());
    },
  );

  test(
    'copy with email',
    () {
      const String expectedEmail = 'wojtekp@example.com';

      state = state.copyWith(email: expectedEmail);
      final state2 = state.copyWith();

      expect(state.email, expectedEmail);
      expect(state2.email, expectedEmail);
    },
  );
}
