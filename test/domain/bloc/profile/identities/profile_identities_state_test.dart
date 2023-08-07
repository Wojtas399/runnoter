import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/profile/identities/profile_identities_bloc.dart';
import 'package:runnoter/domain/entity/user.dart';

void main() {
  late ProfileIdentitiesState state;

  setUp(() {
    state = const ProfileIdentitiesState(
      status: BlocStatusInitial(),
      username: null,
      surname: null,
      email: null,
    );
  });

  test(
    'copy with state',
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
    'copy with username',
    () {
      const String expectedName = 'Jack';

      state = state.copyWith(username: expectedName);
      final state2 = state.copyWith();

      expect(state.username, expectedName);
      expect(state2.username, expectedName);
    },
  );

  test(
    'copy with surname',
    () {
      const String expectedSurname = 'surname';

      state = state.copyWith(surname: expectedSurname);
      final state2 = state.copyWith();

      expect(state.surname, expectedSurname);
      expect(state2.surname, expectedSurname);
    },
  );

  test(
    'copy with email',
    () {
      const String expectedEmail = 'email@example.com';

      state = state.copyWith(email: expectedEmail);
      final state2 = state.copyWith();

      expect(state.email, expectedEmail);
      expect(state2.email, expectedEmail);
    },
  );

  test(
    'copy with is email verified',
    () {
      const bool expected = false;

      state = state.copyWith(isEmailVerified: expected);
      final state2 = state.copyWith();

      expect(state.isEmailVerified, expected);
      expect(state2.isEmailVerified, expected);
    },
  );
}
