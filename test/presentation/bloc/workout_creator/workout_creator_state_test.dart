import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/model/workout_stage.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/workout_creator/bloc/workout_creator_state.dart';

void main() {
  late WorkoutCreatorState state;

  setUp(() {
    state = const WorkoutCreatorState(
      status: BlocStatusInitial(),
      date: null,
      workoutName: null,
      stages: [],
    );
  });

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusInitial();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with date',
    () {
      final DateTime expectedDate = DateTime(2023, 2, 1);

      state = state.copyWith(date: expectedDate);
      final state2 = state.copyWith();

      expect(state.date, expectedDate);
      expect(state2.date, expectedDate);
    },
  );

  test(
    'copy with workout name',
    () {
      const String expectedName = 'workoutName';

      state = state.copyWith(workoutName: expectedName);
      final state2 = state.copyWith();

      expect(state.workoutName, expectedName);
      expect(state2.workoutName, expectedName);
    },
  );

  test(
    'copy with stages',
    () {
      final List<WorkoutStage> expectedStages = [
        WorkoutStageBaseRun(
          distanceInKilometers: 10.0,
          maxHeartRate: 150,
        ),
        const WorkoutStageStretching(),
      ];

      state = state.copyWith(stages: expectedStages);
      final state2 = state.copyWith();

      expect(state.stages, expectedStages);
      expect(state2.stages, expectedStages);
    },
  );
}
