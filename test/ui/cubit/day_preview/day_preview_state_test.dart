import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/race.dart';
import 'package:runnoter/data/entity/workout.dart';
import 'package:runnoter/data/model/health_measurement.dart';
import 'package:runnoter/ui/cubit/day_preview/day_preview_cubit.dart';

import '../../../creators/health_measurement_creator.dart';
import '../../../creators/race_creator.dart';
import '../../../creators/workout_creator.dart';

void main() {
  late DayPreviewState state;

  setUp(
    () => state = const DayPreviewState(),
  );

  test(
    'copy with isPastDate, '
    'should copy current value if new value is null',
    () {
      const bool expected = true;

      state = state.copyWith(isPastDate: expected);
      final state2 = state.copyWith();

      expect(state.isPastDate, expected);
      expect(state2.isPastDate, expected);
    },
  );

  test(
    'copy with canModifyHealthMeasurement, '
    'should copy current value if new value is null',
    () {
      const bool expected = false;

      state = state.copyWith(canModifyHealthMeasurement: expected);
      final state2 = state.copyWith();

      expect(state.canModifyHealthMeasurement, expected);
      expect(state2.canModifyHealthMeasurement, expected);
    },
  );

  test(
    'copy with healthMeasurement, '
    'should copy current value if new value is null',
    () {
      final HealthMeasurement expected = createHealthMeasurement(
        date: DateTime(2023),
      );

      state = state.copyWith(healthMeasurement: expected);
      final state2 = state.copyWith();

      expect(state.healthMeasurement, expected);
      expect(state2.healthMeasurement, expected);
    },
  );

  test(
    'copy with healthMeasurementAsNull, '
    'should set healthMeasurement as null if set to true',
    () {
      final HealthMeasurement expected = createHealthMeasurement(
        date: DateTime(2023),
      );

      state = state.copyWith(healthMeasurement: expected);
      final state2 = state.copyWith(healthMeasurementAsNull: true);

      expect(state.healthMeasurement, expected);
      expect(state2.healthMeasurement, null);
    },
  );

  test(
    'copy with workouts, '
    'should copy current value if new value is null',
    () {
      final List<Workout> expected = [
        createWorkout(id: 'w1'),
        createWorkout(id: 'w2'),
      ];

      state = state.copyWith(workouts: expected);
      final state2 = state.copyWith();

      expect(state.workouts, expected);
      expect(state2.workouts, expected);
    },
  );

  test(
    'copy with races, '
    'should copy current value if new value is null',
    () {
      final List<Race> expected = [createRace(id: 'r1'), createRace(id: 'r2')];

      state = state.copyWith(races: expected);
      final state2 = state.copyWith();

      expect(state.races, expected);
      expect(state2.races, expected);
    },
  );
}
