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
    'are data loaded, '
    'all params are not null, '
    'should be true',
    () {
      state = state.copyWith(
        date: DateTime(2023),
        workoutName: 'workout name',
        stages: [],
        activityStatus: const ActivityStatusPending(),
      );

      expect(state.areDataLoaded, true);
    },
  );

  test(
    'are data loaded, '
    'date is null, '
    'should be false',
    () {
      state = state.copyWith(
        workoutName: 'workout name',
        stages: [],
        activityStatus: const ActivityStatusPending(),
      );

      expect(state.areDataLoaded, false);
    },
  );

  test(
    'are data loaded, '
    'workout name is null, '
    'should be false',
    () {
      state = state.copyWith(
        date: DateTime(2023),
        stages: [],
        activityStatus: const ActivityStatusPending(),
      );

      expect(state.areDataLoaded, false);
    },
  );

  test(
    'are data loaded, '
    'stages are null, '
    'should be false',
    () {
      state = state.copyWith(
        date: DateTime(2023),
        workoutName: 'workout name',
        activityStatus: const ActivityStatusPending(),
      );

      expect(state.areDataLoaded, false);
    },
  );

  test(
    'are data loaded, '
    'activity status is null, '
    'should be false',
    () {
      state = state.copyWith(
        date: DateTime(2023),
        workoutName: 'workout name',
        stages: [],
      );

      expect(state.areDataLoaded, false);
    },
  );

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
    'copy with canEditWorkoutStatus',
    () {
      const bool expected = false;

      state = state.copyWith(canEditWorkoutStatus: expected);
      final state2 = state.copyWith();

      expect(state.canEditWorkoutStatus, expected);
      expect(state2.canEditWorkoutStatus, expected);
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
    'copy with workoutName',
    () {
      const String expectedWorkoutName = 'workout name';

      state = state.copyWith(workoutName: expectedWorkoutName);
      final state2 = state.copyWith();

      expect(state.workoutName, expectedWorkoutName);
      expect(state2.workoutName, expectedWorkoutName);
    },
  );

  test(
    'copy with stages',
    () {
      const List<WorkoutStage> expectedStages = [
        WorkoutStageCardio(
          distanceInKm: 2,
          maxHeartRate: 150,
        ),
        WorkoutStageZone2(
          distanceInKm: 5,
          maxHeartRate: 165,
        ),
      ];

      state = state.copyWith(stages: expectedStages);
      final state2 = state.copyWith();

      expect(state.stages, expectedStages);
      expect(state2.stages, expectedStages);
    },
  );

  test(
    'copy with activityStatus',
    () {
      const ActivityStatus expectedActivityStatus = ActivityStatusPending();

      state = state.copyWith(activityStatus: expectedActivityStatus);
      final state2 = state.copyWith();

      expect(state.activityStatus, expectedActivityStatus);
      expect(state2.activityStatus, expectedActivityStatus);
    },
  );
}
