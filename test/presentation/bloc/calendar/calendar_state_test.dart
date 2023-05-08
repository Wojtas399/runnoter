import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/model/workout.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/calendar/bloc/calendar_bloc.dart';

import '../../../util/workout_creator.dart';

void main() {
  late CalendarState state;

  setUp(
    () => state = const CalendarState(
      status: BlocStatusInitial(),
      workouts: null,
    ),
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
    'copy with workouts',
    () {
      final List<Workout> expectedWorkouts = [
        createWorkout(id: 'w1', name: 'workout 1'),
        createWorkout(id: 'w2', name: 'workout 2'),
      ];

      state = state.copyWith(workouts: expectedWorkouts);
      final state2 = state.copyWith();

      expect(state.workouts, expectedWorkouts);
      expect(state2.workouts, expectedWorkouts);
    },
  );
}
