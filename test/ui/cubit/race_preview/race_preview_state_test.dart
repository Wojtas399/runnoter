import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/additional_model/activity_status.dart';
import 'package:runnoter/ui/cubit/race_preview/race_preview_cubit.dart';

void main() {
  late RacePreviewState state;

  setUp(
    () => state = const RacePreviewState(),
  );

  test(
    'is race loaded, '
    'name, date, place, distance and race status are not null, '
    'should return true',
    () {
      state = state.copyWith(
        name: 'race name',
        date: DateTime(2023, 1, 2),
        place: 'place',
        distance: 20,
        raceStatus: const ActivityStatusPending(),
      );

      expect(state.isRaceLoaded, true);
    },
  );

  test(
    'is race loaded, '
    'name is null, '
    'should return false',
    () {
      state = state.copyWith(
        date: DateTime(2023, 1, 2),
        place: 'place',
        distance: 20,
        raceStatus: const ActivityStatusPending(),
      );

      expect(state.isRaceLoaded, false);
    },
  );

  test(
    'is race loaded, '
    'date is null, '
    'should return false',
    () {
      state = state.copyWith(
        name: 'race name',
        place: 'place',
        distance: 20,
        raceStatus: const ActivityStatusPending(),
      );

      expect(state.isRaceLoaded, false);
    },
  );

  test(
    'is race loaded, '
    'place is null, '
    'should return false',
    () {
      state = state.copyWith(
        name: 'race name',
        date: DateTime(2023, 1, 2),
        distance: 20,
        raceStatus: const ActivityStatusPending(),
      );

      expect(state.isRaceLoaded, false);
    },
  );

  test(
    'is race loaded, '
    'distance is null, '
    'should return false',
    () {
      state = state.copyWith(
        name: 'race name',
        date: DateTime(2023, 1, 2),
        place: 'place',
        raceStatus: const ActivityStatusPending(),
      );

      expect(state.isRaceLoaded, false);
    },
  );

  test(
    'is race loaded, '
    'raceStatus is null, '
    'should return false',
    () {
      state = state.copyWith(
        name: 'race name',
        date: DateTime(2023, 1, 2),
        place: 'place',
        distance: 20,
      );

      expect(state.isRaceLoaded, false);
    },
  );

  test(
    'copy with name, '
    'should copy current value if new value is null',
    () {
      const String expected = 'race name';

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
      final DateTime expected = DateTime(2023, 1, 2);

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
      const String expected = 'place name';

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
      const double expected = 21;

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
      const Duration expected = Duration(hours: 1, minutes: 30);

      state = state.copyWith(expectedDuration: expected);
      final state2 = state.copyWith();

      expect(state.expectedDuration, expected);
      expect(state2.expectedDuration, expected);
    },
  );

  test(
    'copy with raceStatus, '
    'should copy current value if new value is null',
    () {
      const ActivityStatus expected = ActivityStatusPending();

      state = state.copyWith(raceStatus: expected);
      final state2 = state.copyWith();

      expect(state.raceStatus, expected);
      expect(state2.raceStatus, expected);
    },
  );
}
