import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/model/user.dart';
import 'package:runnoter/ui/cubit/person_details/person_details_cubit.dart';

void main() {
  late PersonDetailsState state;

  setUp(() {
    state = const PersonDetailsState();
  });

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
}
