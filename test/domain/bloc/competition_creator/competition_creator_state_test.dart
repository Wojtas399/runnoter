import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/competition_creator/competition_creator_bloc.dart';

void main() {
  late CompetitionCreatorState state;

  setUp(
    () => state = const CompetitionCreatorState(
      status: BlocStatusInitial(),
    ),
  );

  test(
    'are data valid, '
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

      expect(state.areDataValid, false);
    },
  );

  test(
    'are data valid, '
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

      expect(state.areDataValid, false);
    },
  );

  test(
    'are data valid, '
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

      expect(state.areDataValid, false);
    },
  );

  test(
    'are data valid, '
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

      expect(state.areDataValid, false);
    },
  );

  test(
    'are data valid, '
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

      expect(state.areDataValid, false);
    },
  );

  test(
    'are data valid, '
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

      expect(state.areDataValid, false);
    },
  );

  test(
    'are data valid, '
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

      expect(state.areDataValid, false);
    },
  );

  test(
    'are data valid, '
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

      expect(state.areDataValid, false);
    },
  );

  test(
    'are data valid, '
    'expected duration is null, '
    'should be false',
    () {
      state = state.copyWith(
        name: 'name',
        date: DateTime(2023, 5, 10),
        place: 'place',
        distance: 21,
        expectedDuration: null,
      );

      expect(state.areDataValid, false);
    },
  );

  test(
    'are data valid, '
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

      expect(state.areDataValid, true);
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
    'copy with name',
    () {
      const String expectedName = 'name 1';

      state = state.copyWith(name: expectedName);
      final state2 = state.copyWith();

      expect(state.name, expectedName);
      expect(state2.name, expectedName);
    },
  );

  test(
    'copy with date',
    () {
      final DateTime expectedDate = DateTime(2023, 5, 10);

      state = state.copyWith(date: expectedDate);
      final state2 = state.copyWith();

      expect(state.date, expectedDate);
      expect(state2.date, expectedDate);
    },
  );

  test(
    'copy with place',
    () {
      const String expectedPlace = 'place 1';

      state = state.copyWith(place: expectedPlace);
      final state2 = state.copyWith();

      expect(state.place, expectedPlace);
      expect(state2.place, expectedPlace);
    },
  );

  test(
    'copy with distance',
    () {
      const double expectedDistance = 10;

      state = state.copyWith(distance: expectedDistance);
      final state2 = state.copyWith();

      expect(state.distance, expectedDistance);
      expect(state2.distance, expectedDistance);
    },
  );

  test(
    'copy with expected duration',
    () {
      const Duration expectedDuration = Duration(
        hours: 1,
        minutes: 45,
        seconds: 20,
      );

      state = state.copyWith(expectedDuration: expectedDuration);
      final state2 = state.copyWith();

      expect(state.expectedDuration, expectedDuration);
      expect(state2.expectedDuration, expectedDuration);
    },
  );
}
