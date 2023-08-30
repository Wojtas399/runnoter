import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/client_workouts/client_workouts_state.dart';
import 'package:runnoter/domain/entity/race.dart';
import 'package:runnoter/domain/entity/workout.dart';

import '../../../creators/race_creator.dart';
import '../../../creators/workout_creator.dart';

void main() {
  late ClientWorkoutsState state;

  setUp(
    () => state = const ClientWorkoutsState(status: BlocStatusInitial()),
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
    'copy with range',
    () {
      const WorkoutsRange expectedRange = WorkoutsRange.month;

      state = state.copyWith(range: expectedRange);
      final state2 = state.copyWith();

      expect(state.range, expectedRange);
      expect(state2.range, expectedRange);
    },
  );

  test(
    'copy with workouts',
    () {
      final List<Workout> expectedWorkouts = [
        createWorkout(id: 'w1'),
        createWorkout(id: 'w2'),
      ];

      state = state.copyWith(workouts: expectedWorkouts);
      final state2 = state.copyWith();

      expect(state.workouts, expectedWorkouts);
      expect(state2.workouts, expectedWorkouts);
    },
  );

  test(
    'copy with races',
    () {
      final List<Race> expectedRaces = [
        createRace(id: 'r1'),
        createRace(id: 'r2'),
      ];

      state = state.copyWith(races: expectedRaces);
      final state2 = state.copyWith();

      expect(state.races, expectedRaces);
      expect(state2.races, expectedRaces);
    },
  );
}
