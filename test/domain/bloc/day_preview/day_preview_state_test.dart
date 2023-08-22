import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/day_preview/day_preview_bloc.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';
import 'package:runnoter/domain/entity/race.dart';
import 'package:runnoter/domain/entity/workout.dart';

import '../../../creators/health_measurement_creator.dart';
import '../../../creators/race_creator.dart';
import '../../../creators/workout_creator.dart';

void main() {
  late DayPreviewState state;

  setUp(
    () => state = const DayPreviewState(status: BlocStatusInitial()),
  );

  test(
    'copy with status',
    () {
      const BlocStatus expected = BlocStatusLoading();

      state = state.copyWith(status: expected);
      final state2 = state.copyWith();

      expect(state.status, expected);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with isPastDay',
    () {
      const bool expected = true;

      state = state.copyWith(isPastDay: expected);
      final state2 = state.copyWith();

      expect(state.isPastDay, expected);
      expect(state2.isPastDay, expected);
    },
  );

  test(
    'copy with healthMeasurement',
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
    'copy with healthMeasurementAsNull',
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
    'copy with workouts',
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
    'copy with races',
    () {
      final List<Race> expected = [createRace(id: 'r1'), createRace(id: 'r2')];

      state = state.copyWith(races: expected);
      final state2 = state.copyWith();

      expect(state.races, expected);
      expect(state2.races, expected);
    },
  );
}
