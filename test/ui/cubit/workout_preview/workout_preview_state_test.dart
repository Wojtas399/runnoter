import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/workout.dart';
import 'package:runnoter/data/model/activity.dart';
import 'package:runnoter/ui/cubit/workout_preview/workout_preview_cubit.dart';

void main() {
  late WorkoutPreviewState state;

  setUp(() {
    state = const WorkoutPreviewState();
  });

  test(
    'is workout loaded, '
    'all params are not null, '
    'should be true',
    () {
      state = state.copyWith(
        date: DateTime(2023),
        workoutName: 'workout name',
        stages: [],
        activityStatus: const ActivityStatusPending(),
      );

      expect(state.isWorkoutLoaded, true);
    },
  );

  test(
    'is workout loaded, '
    'date is null, '
    'should be false',
    () {
      state = state.copyWith(
        workoutName: 'workout name',
        stages: [],
        activityStatus: const ActivityStatusPending(),
      );

      expect(state.isWorkoutLoaded, false);
    },
  );

  test(
    'is workout loaded, '
    'workout name is null, '
    'should be false',
    () {
      state = state.copyWith(
        date: DateTime(2023),
        stages: [],
        activityStatus: const ActivityStatusPending(),
      );

      expect(state.isWorkoutLoaded, false);
    },
  );

  test(
    'is workout loaded, '
    'stages are null, '
    'should be false',
    () {
      state = state.copyWith(
        date: DateTime(2023),
        workoutName: 'workout name',
        activityStatus: const ActivityStatusPending(),
      );

      expect(state.isWorkoutLoaded, false);
    },
  );

  test(
    'is workout loaded, '
    'activity status is null, '
    'should be false',
    () {
      state = state.copyWith(
        date: DateTime(2023),
        workoutName: 'workout name',
        stages: [],
      );

      expect(state.isWorkoutLoaded, false);
    },
  );

  test(
    'copy with date, '
    'should copy current value if new value is null',
    () {
      final DateTime expected = DateTime(2023, 1, 10);

      state = state.copyWith(date: expected);
      final state2 = state.copyWith();

      expect(state.date, expected);
      expect(state2.date, expected);
    },
  );

  test(
    'copy with workoutName, '
    'should copy current value if new value is null',
    () {
      const String expected = 'workout name';

      state = state.copyWith(workoutName: expected);
      final state2 = state.copyWith();

      expect(state.workoutName, expected);
      expect(state2.workoutName, expected);
    },
  );

  test(
    'copy with stages, '
    'should copy current value if new value is null',
    () {
      const List<WorkoutStage> expected = [
        WorkoutStageCardio(
          distanceInKm: 2,
          maxHeartRate: 150,
        ),
        WorkoutStageZone2(
          distanceInKm: 5,
          maxHeartRate: 165,
        ),
      ];

      state = state.copyWith(stages: expected);
      final state2 = state.copyWith();

      expect(state.stages, expected);
      expect(state2.stages, expected);
    },
  );

  test(
    'copy with activityStatus, '
    'should copy current value if new value is null',
    () {
      const ActivityStatus expected = ActivityStatusPending();

      state = state.copyWith(activityStatus: expected);
      final state2 = state.copyWith();

      expect(state.activityStatus, expected);
      expect(state2.activityStatus, expected);
    },
  );
}
