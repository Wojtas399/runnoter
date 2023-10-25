import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/model/user.dart';
import 'package:runnoter/ui/cubit/sign_up/sign_up_cubit.dart';
import 'package:runnoter/ui/model/cubit_status.dart';

void main() {
  late SignUpState state;

  setUp(() {
    state = const SignUpState(
      status: CubitStatusInitial(),
    );
  });

  test(
    'is password confirmation valid, '
    "passwords aren't the same, "
    'should be false',
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
    'is password confirmation valid, '
    'passwords are the same, '
    'should be true',
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
    'can submit, '
    'all params are valid, '
    'should be true',
    () {
      state = state.copyWith(
        gender: Gender.male,
        name: 'Jack',
        surname: 'Obvsky',
        email: 'jack@example.com',
        dateOfBirth: DateTime(2023, 1, 10),
        password: 'Password123!',
        passwordConfirmation: 'Password123!',
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'name is invalid, '
    'should be false',
    () {
      state = state.copyWith(
        gender: Gender.male,
        name: 'J',
        surname: 'Obvsky',
        email: 'jack@example.com',
        dateOfBirth: DateTime(2023, 1, 10),
        password: 'Password123!',
        passwordConfirmation: 'Password123!',
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'surname is invalid, '
    'should be false',
    () {
      state = state.copyWith(
        gender: Gender.male,
        name: 'Jack',
        surname: 'O',
        email: 'jack@example.com',
        dateOfBirth: DateTime(2023, 1, 10),
        password: 'Password123!',
        passwordConfirmation: 'Password123!',
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'email is invalid, '
    'should be false',
    () {
      state = state.copyWith(
        gender: Gender.male,
        name: 'Jack',
        surname: 'Obvsky',
        email: 'jackexample.com',
        dateOfBirth: DateTime(2023, 1, 10),
        password: 'Password123!',
        passwordConfirmation: 'Password123!',
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'date of birth is null, '
    'should be false',
    () {
      state = state.copyWith(
        gender: Gender.male,
        name: 'Jack',
        surname: 'Obvsky',
        email: 'jack@example.com',
        password: 'Password123!',
        passwordConfirmation: 'Password123!',
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'password is invalid, '
    'should be false',
    () {
      state = state.copyWith(
        gender: Gender.male,
        name: 'Jack',
        surname: 'Obvsky',
        email: 'jack@example.com',
        dateOfBirth: DateTime(2023, 1, 10),
        password: 'Password123',
        passwordConfirmation: 'Password123!',
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'password confirmation is invalid, '
    'should be false',
    () {
      state = state.copyWith(
        gender: Gender.male,
        name: 'Jack',
        surname: 'Obvsky',
        email: 'jack@example.com',
        dateOfBirth: DateTime(2023, 1, 10),
        password: 'Password123!',
        passwordConfirmation: 'Password123',
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'copy with status, '
    'should set complete status if new value is null',
    () {
      const CubitStatus expectedStatus = CubitStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const CubitStatusComplete());
    },
  );

  test(
    'copy with account type, '
    'should copy current value if new value is null',
    () {
      const AccountType expectedAccountType = AccountType.coach;

      state = state.copyWith(accountType: expectedAccountType);
      final state2 = state.copyWith();

      expect(state.accountType, expectedAccountType);
      expect(state2.accountType, expectedAccountType);
    },
  );

  test(
    'copy with gender, '
    'should copy current value if new value is null',
    () {
      const Gender expectedGender = Gender.female;

      state = state.copyWith(gender: expectedGender);
      final state2 = state.copyWith();

      expect(state.gender, expectedGender);
      expect(state2.gender, expectedGender);
    },
  );

  test(
    'copy with name, '
    'should copy current value if new value is null',
    () {
      const String expectedName = 'Jack';

      state = state.copyWith(name: expectedName);
      final state2 = state.copyWith();

      expect(state.name, expectedName);
      expect(state2.name, expectedName);
    },
  );

  test(
    'copy with surname, '
    'should copy current value if new value is null',
    () {
      const String expectedSurname = 'Sparrowsky';

      state = state.copyWith(surname: expectedSurname);
      final state2 = state.copyWith();

      expect(state.surname, expectedSurname);
      expect(state2.surname, expectedSurname);
    },
  );

  test(
    'copy with email, '
    'should copy current value if new value is null',
    () {
      const String expectedEmail = 'jack@example.com';

      state = state.copyWith(email: expectedEmail);
      final state2 = state.copyWith();

      expect(state.email, expectedEmail);
      expect(state2.email, expectedEmail);
    },
  );

  test(
    'copy with dateOfBirth, '
    'should copy current value if new value is null',
    () {
      final DateTime expected = DateTime(2023, 1, 10);

      state = state.copyWith(dateOfBirth: expected);
      final state2 = state.copyWith();

      expect(state.dateOfBirth, expected);
      expect(state2.dateOfBirth, expected);
    },
  );

  test(
    'copy with password, '
    'should copy current value if new value is null',
    () {
      const String expectedPassword = 'password123';

      state = state.copyWith(password: expectedPassword);
      final state2 = state.copyWith();

      expect(state.password, expectedPassword);
      expect(state2.password, expectedPassword);
    },
  );

  test(
    'copy with password confirmation, '
    'should copy current value if new value is null',
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
