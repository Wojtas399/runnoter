import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/cubit/client/client_cubit.dart';

void main() {
  late ClientState state;

  setUp(
    () => state = const ClientState(),
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
}
