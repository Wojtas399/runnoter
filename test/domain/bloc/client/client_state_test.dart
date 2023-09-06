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
      const BlocStatus expected = BlocStatusComplete();

      state = state.copyWith(status: expected);
      final state2 = state.copyWith();

      expect(state.status, expected);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with gender, '
    'should copy current value if new value is null',
    () {
      const Gender expected = Gender.male;

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
      const String expected = 'name';

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
    'copy with age, '
    'should copy current value if new value is null',
    () {
      const int expected = 30;

      state = state.copyWith(age: expected);
      final state2 = state.copyWith();

      expect(state.age, expected);
      expect(state2.age, expected);
    },
  );
}
