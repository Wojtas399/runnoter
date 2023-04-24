import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/model/workout.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/day_preview/bloc/day_preview_state.dart';

import '../../../util/workout_creator.dart';

void main() {
  late DayPreviewState state;

  setUp(() {
    state = const DayPreviewState(
      status: BlocStatusInitial(),
      date: null,
      workout: null,
    );
  });

  test(
    'copy with status',
    () {
      const BlocStatus expectedBlocStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedBlocStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedBlocStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with date',
    () {
      final DateTime expectedDate = DateTime(2023, 1, 10);

      state = state.copyWith(date: expectedDate);
      final state2 = state.copyWith();

      expect(state.date, expectedDate);
      expect(state2.date, expectedDate);
    },
  );

  test(
    'copy with workout',
    () {
      final Workout expectedWorkout = createWorkout(
        id: 'w1',
        userId: 'u1',
        name: 'workout name',
      );

      state = state.copyWith(workout: expectedWorkout);
      final state2 = state.copyWith();

      expect(state.workout, expectedWorkout);
      expect(state2.workout, expectedWorkout);
    },
  );
}
