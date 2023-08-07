import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/required_data_completion/required_data_completion_bloc.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/use_case/add_user_data_use_case.dart';

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
          status: BlocStatusInitial(),
          gender: Gender.male,
          name: '',
          surname: '',
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
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'name and surname are valid, '
    'should be true',
    () {
      state = state.copyWith(
        gender: Gender.male,
        name: 'Jack',
        surname: 'Erl',
      );

      expect(state.canSubmit, true);
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
    'copy with account type',
    () {
      const AccountType expectedAccountType = AccountType.coach;

      state = state.copyWith(accountType: expectedAccountType);
      final state2 = state.copyWith();

      expect(state.accountType, expectedAccountType);
      expect(state2.accountType, expectedAccountType);
    },
  );

  test(
    'copy with gender',
    () {
      const Gender expectedGender = Gender.female;

      state = state.copyWith(gender: expectedGender);
      final state2 = state.copyWith();

      expect(state.gender, expectedGender);
      expect(state2.gender, expectedGender);
    },
  );

  test(
    'copy with name',
    () {
      const String expectedName = 'Jack';

      state = state.copyWith(name: expectedName);
      final state2 = state.copyWith(name: expectedName);

      expect(state.name, expectedName);
      expect(state2.name, expectedName);
    },
  );

  test(
    'copy with surname',
    () {
      const String expectedSurname = 'Erl';

      state = state.copyWith(surname: expectedSurname);
      final state2 = state.copyWith();

      expect(state.surname, expectedSurname);
      expect(state2.surname, expectedSurname);
    },
  );
}
