import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/activity_status.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/workout_stage.dart';
import 'package:runnoter/domain/bloc/workout_preview/workout_preview_bloc.dart';

void main() {
  late WorkoutPreviewState state;

  setUp(() {
    state = const WorkoutPreviewState(
      status: BlocStatusInitial(),
    );
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
    'copy with date',
    () {
      final DateTime expected = DateTime(2023, 1, 10);

      state = state.copyWith(date: expected);
      final state2 = state.copyWith();

      expect(state.date, expected);
      expect(state2.date, expected);
    },
  );

  test(
    'copy with workoutName',
    () {
      const String expected = 'workout name';

      state = state.copyWith(workoutName: expected);
      final state2 = state.copyWith();

      expect(state.workoutName, expected);
      expect(state2.workoutName, expected);
    },
  );

  test(
    'copy with stages',
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
    'copy with activityStatus',
    () {
      const ActivityStatus expected = ActivityStatusPending();

      state = state.copyWith(activityStatus: expected);
      final state2 = state.copyWith();

      expect(state.activityStatus, expected);
      expect(state2.activityStatus, expected);
    },
  );
}
