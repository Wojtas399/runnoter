import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/ui/cubit/profile/identities/profile_identities_cubit.dart';
import 'package:runnoter/ui/model/cubit_status.dart';

void main() {
  late ProfileIdentitiesState state;

  setUp(() {
    state = const ProfileIdentitiesState(status: CubitStatusInitial());
  });

  test(
    'copy with state, '
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
    'copy with accountType, '
    'should copy current value if new value is null',
    () {
      const AccountType expected = AccountType.coach;

      state = state.copyWith(accountType: expected);
      final state2 = state.copyWith();

      expect(state.accountType, expected);
      expect(state2.accountType, expected);
    },
  );

  test(
    'copy with gender, '
    'should copy current value if new value is null',
    () {
      const Gender expected = Gender.female;

      state = state.copyWith(gender: expected);
      final state2 = state.copyWith();

      expect(state.gender, expected);
      expect(state2.gender, expected);
    },
  );

  test(
    'copy with name, '
    'should copy current value if new value is null',
    () {
      const String expected = 'Jack';

      state = state.copyWith(name: expected);
      final state2 = state.copyWith();

      expect(state.name, expected);
      expect(state2.name, expected);
    },
  );

  test(
    'copy with surname, '
    'should copy current value if new value is null',
    () {
      const String expected = 'surname';

      state = state.copyWith(surname: expected);
      final state2 = state.copyWith();

      expect(state.surname, expected);
      expect(state2.surname, expected);
    },
  );

  test(
    'copy with email, '
    'should copy current value if new value is null',
    () {
      const String expected = 'email@example.com';

      state = state.copyWith(email: expected);
      final state2 = state.copyWith();

      expect(state.email, expected);
      expect(state2.email, expected);
    },
  );

  test(
    'copy with dateOfBirth, '
    'should copy current value if new value is null',
    () {
      final DateTime expected = DateTime(2023, 1, 11);

      state = state.copyWith(dateOfBirth: expected);
      final state2 = state.copyWith();

      expect(state.dateOfBirth, expected);
      expect(state2.dateOfBirth, expected);
    },
  );

  test(
    'copy with isEmailVerified, '
    'should copy current value if new value is null',
    () {
      const bool expected = false;

      state = state.copyWith(isEmailVerified: expected);
      final state2 = state.copyWith();

      expect(state.isEmailVerified, expected);
      expect(state2.isEmailVerified, expected);
    },
  );
}
