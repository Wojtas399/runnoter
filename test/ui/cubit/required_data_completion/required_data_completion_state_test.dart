import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/model/user.dart';
import 'package:runnoter/ui/cubit/required_data_completion/required_data_completion_cubit.dart';
import 'package:runnoter/ui/model/cubit_status.dart';

void main() {
  late RequiredDataCompletionState state;

  setUp(
    () => state = const RequiredDataCompletionState(),
  );

  test(
    'initial data',
    () {
      expect(
        state,
        const RequiredDataCompletionState(
          status: CubitStatusInitial(),
          accountType: AccountType.runner,
          gender: Gender.male,
          name: '',
          surname: '',
          dateOfBirth: null,
        ),
      );
    },
  );

  test(
    'can submit, '
    'name is empty string, '
    'should be false',
    () {
      state = state.copyWith(
        gender: Gender.male,
        name: '',
        surname: 'Erl',
        dateOfBirth: DateTime(2023, 1, 10),
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'surname is empty string, '
    'should be false',
    () {
      state = state.copyWith(
        gender: Gender.male,
        name: 'Jack',
        surname: '',
        dateOfBirth: DateTime(2023, 1, 10),
      );

      expect(state.canSubmit, false);
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
        surname: 'Erl',
        dateOfBirth: DateTime(2023, 1, 10),
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
        surname: 'E',
        dateOfBirth: DateTime(2023, 1, 10),
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'dateOfBirth is null, '
    'should be false',
    () {
      state = state.copyWith(
        gender: Gender.male,
        name: 'Jack',
        surname: 'Erl',
        dateOfBirth: null,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'name and surname are valid and dateOfBirth is not null, '
    'should be true',
    () {
      state = state.copyWith(
        gender: Gender.male,
        name: 'Jack',
        surname: 'Erl',
        dateOfBirth: DateTime(2023, 1, 10),
      );

      expect(state.canSubmit, true);
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
      final state2 = state.copyWith(name: expectedName);

      expect(state.name, expectedName);
      expect(state2.name, expectedName);
    },
  );

  test(
    'copy with surname, '
    'should copy current value if new value is null',
    () {
      const String expectedSurname = 'Erl';

      state = state.copyWith(surname: expectedSurname);
      final state2 = state.copyWith();

      expect(state.surname, expectedSurname);
      expect(state2.surname, expectedSurname);
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
}
