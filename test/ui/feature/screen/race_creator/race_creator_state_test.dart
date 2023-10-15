import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/race.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/ui/feature/screen/race_creator/cubit/race_creator_cubit.dart';

import '../../../../creators/race_creator.dart';

void main() {
  late RaceCreatorState state;

  setUp(
    () => state = const RaceCreatorState(status: CubitStatusInitial()),
  );

  test(
    'can submit, '
    'name is null, '
    'should be false',
    () {
      state = state.copyWith(
        name: null,
        date: DateTime(2023, 5, 10),
        place: 'place',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'name is empty, '
    'should be false',
    () {
      state = state.copyWith(
        name: '',
        date: DateTime(2023, 5, 10),
        place: 'place',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'date is null, '
    'should be false',
    () {
      state = state.copyWith(
        name: 'name',
        date: null,
        place: 'place',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'place is null, '
    'should be false',
    () {
      state = state.copyWith(
        name: 'name',
        date: DateTime(2023, 5, 10),
        place: null,
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'place is empty, '
    'should be false',
    () {
      state = state.copyWith(
        name: 'name',
        date: DateTime(2023, 5, 10),
        place: '',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'distance is null, '
    'should be false',
    () {
      state = state.copyWith(
        name: 'name',
        date: DateTime(2023, 5, 10),
        place: 'place',
        distance: null,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'distance is lower than 0, '
    'should be false',
    () {
      state = state.copyWith(
        name: 'name',
        date: DateTime(2023, 5, 10),
        place: 'place',
        distance: -10,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'distance is equal to 0, '
    'should be false',
    () {
      state = state.copyWith(
        name: 'name',
        date: DateTime(2023, 5, 10),
        place: 'place',
        distance: 0,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'all data are valid, '
    'should be true',
    () {
      state = state.copyWith(
        name: 'name',
        date: DateTime(2023, 5, 10),
        place: 'place',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'name is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        race: createRace(
          name: 'name',
          date: DateTime(2023, 5, 20),
          place: 'place',
          distance: 21,
          expectedDuration: const Duration(seconds: 5),
        ),
        name: 'new name',
        date: DateTime(2023, 5, 20),
        place: 'place',
        distance: 21,
        expectedDuration: const Duration(seconds: 5),
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'date is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        race: createRace(
          name: 'name',
          date: DateTime(2023, 5, 20),
          place: 'place',
          distance: 21,
          expectedDuration: const Duration(seconds: 5),
        ),
        name: 'name',
        date: DateTime(2023, 5, 21),
        place: 'place',
        distance: 21,
        expectedDuration: const Duration(seconds: 5),
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'place is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        race: createRace(
          name: 'name',
          date: DateTime(2023, 5, 20),
          place: 'place',
          distance: 21,
          expectedDuration: const Duration(seconds: 5),
        ),
        name: 'name',
        date: DateTime(2023, 5, 20),
        place: 'new place',
        distance: 21,
        expectedDuration: const Duration(seconds: 5),
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'distance is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        race: createRace(
          name: 'name',
          date: DateTime(2023, 5, 20),
          place: 'place',
          distance: 21,
          expectedDuration: const Duration(seconds: 5),
        ),
        name: 'name',
        date: DateTime(2023, 5, 20),
        place: 'place',
        distance: 20,
        expectedDuration: const Duration(seconds: 5),
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'expected duration is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        race: createRace(
          name: 'name',
          date: DateTime(2023, 5, 20),
          place: 'place',
          distance: 21,
          expectedDuration: const Duration(seconds: 5),
        ),
        name: 'name',
        date: DateTime(2023, 5, 20),
        place: 'place',
        distance: 21,
        expectedDuration: const Duration(seconds: 50),
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'copy with status, '
    'should set complete status if new status is null',
    () {
      const CubitStatus expectedStatus = CubitStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const CubitStatusComplete());
    },
  );

  test(
    'copy with race, '
    'should copy current value if new value is null',
    () {
      final Race expected = createRace(id: 'c1');

      state = state.copyWith(race: expected);
      final state2 = state.copyWith();

      expect(state.race, expected);
      expect(state2.race, expected);
    },
  );

  test(
    'copy with name, '
    'should copy current value if new value is null',
    () {
      const String expected = 'name 1';

      state = state.copyWith(name: expected);
      final state2 = state.copyWith();

      expect(state.name, expected);
      expect(state2.name, expected);
    },
  );

  test(
    'copy with date, '
    'should copy current value if new value is null',
    () {
      final DateTime expected = DateTime(2023, 5, 10);

      state = state.copyWith(date: expected);
      final state2 = state.copyWith();

      expect(state.date, expected);
      expect(state2.date, expected);
    },
  );

  test(
    'copy with place, '
    'should copy current value if new value is null',
    () {
      const String expected = 'place 1';

      state = state.copyWith(place: expected);
      final state2 = state.copyWith();

      expect(state.place, expected);
      expect(state2.place, expected);
    },
  );

  test(
    'copy with distance, '
    'should copy current value if new value is null',
    () {
      const double expected = 10;

      state = state.copyWith(distance: expected);
      final state2 = state.copyWith();

      expect(state.distance, expected);
      expect(state2.distance, expected);
    },
  );

  test(
    'copy with expectedDuration, '
    'should copy current value if new value is null',
    () {
      const Duration expected = Duration(
        hours: 1,
        minutes: 45,
        seconds: 20,
      );

      state = state.copyWith(expectedDuration: expected);
      final state2 = state.copyWith();

      expect(state.expectedDuration, expected);
      expect(state2.expectedDuration, expected);
    },
  );
}
