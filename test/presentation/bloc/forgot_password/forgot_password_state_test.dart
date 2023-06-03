import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/presentation/screen/forgot_password/bloc/forgot_password_state.dart';

void main() {
  late ForgotPasswordState state;

  setUp(() {
    state = const ForgotPasswordState(
      status: BlocStatusInitial(),
      email: '',
    );
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
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
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
