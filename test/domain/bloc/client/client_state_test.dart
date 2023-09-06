import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/cubit/client/client_cubit.dart';
import 'package:runnoter/domain/entity/user.dart';

void main() {
  late ClientState state;

  setUp(
    () => state = const ClientState(status: BlocStatusInitial()),
  );

  test(
    'copy with status, '
    'should set complete status if new value is null',
    () {
      const BlocStatus expectedStatus = BlocStatusComplete();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with gender, '
    'should copy current value if new value is null',
    () {
      const Gender expectedGender = Gender.male;

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
      const String expectedName = 'name';

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
      const String expectedSurname = 'surname';

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
      const String expectedEmail = 'email@example.com';

      state = state.copyWith(email: expectedEmail);
      final state2 = state.copyWith();

      expect(state.email, expectedEmail);
      expect(state2.email, expectedEmail);
    },
  );
}
