import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/model/workout_stage.dart';
import 'package:runnoter/domain/model/workout_status.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/day_preview/bloc/day_preview_state.dart';

void main() {
  late DayPreviewState state;

  setUp(() {
    state = const DayPreviewState(
      status: BlocStatusInitial(),
    );
  });

  test(
    'does workout exist, '
    'workout name, stages and status arent null, '
    'should be true',
    () {
      state = state.copyWith(
        workoutName: 'workout name',
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 10,
            maxHeartRate: 150,
          ),
        ],
        workoutStatus: const WorkoutStatusPending(),
      );

      expect(state.doesWorkoutExist, true);
    },
  );

  test(
    'does workout exist, '
    'workout name is null, '
    'should be false',
    () {
      state = state.copyWith(
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 10,
            maxHeartRate: 150,
          ),
        ],
        workoutStatus: const WorkoutStatusPending(),
      );

      expect(state.doesWorkoutExist, false);
    },
  );

  test(
    'does workout exist, '
    'list of stages is null, '
    'should be true',
    () {
      state = state.copyWith(
        workoutName: 'workout name',
        workoutStatus: const WorkoutStatusPending(),
      );

      expect(state.doesWorkoutExist, false);
    },
  );

  test(
    'does workout exist, '
    'workout status is null, '
    'should be true',
    () {
      state = state.copyWith(
        workoutName: 'workout name',
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 10,
            maxHeartRate: 150,
          ),
        ],
      );

      expect(state.doesWorkoutExist, false);
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
    'copy with workout name',
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
      final List<WorkoutStage> expectedStages = [
        WorkoutStageBaseRun(
          distanceInKilometers: 2,
          maxHeartRate: 150,
        ),
        WorkoutStageZone2(
          distanceInKilometers: 5,
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
    'copy with workout status',
    () {
      const WorkoutStatus expectedWorkoutStatus = WorkoutStatusPending();

      state = state.copyWith(workoutStatus: expectedWorkoutStatus);
      final state2 = state.copyWith();

      expect(state.workoutStatus, expectedWorkoutStatus);
      expect(state2.workoutStatus, expectedWorkoutStatus);
    },
  );
}
