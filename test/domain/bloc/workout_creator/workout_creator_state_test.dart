import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/workout_creator/workout_creator_bloc.dart';
import 'package:runnoter/domain/entity/workout.dart';
import 'package:runnoter/domain/entity/workout_stage.dart';

import '../../../creators/workout_creator.dart';

void main() {
  late WorkoutCreatorState state;

  setUp(() {
    state = const WorkoutCreatorState(
      status: BlocStatusInitial(),
      date: null,
      workout: null,
      workoutName: null,
      stages: [],
    );
  });

  test(
    'is submit button disabled, '
    'date is null, '
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

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'workout name is null, '
    'should be true',
    () {
      state = state.copyWith(
        date: DateTime(2023, 2, 2),
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 10,
            maxHeartRate: 150,
          ),
        ],
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'workout name is empty, '
    'should be true',
    () {
      state = state.copyWith(
        date: DateTime(2023, 2, 2),
        workoutName: '',
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 10,
            maxHeartRate: 150,
          ),
        ],
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'workout stages list is empty, '
    'should be true',
    () {
      state = state.copyWith(
        date: DateTime(2023, 2, 2),
        workoutName: 'workout name',
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'workout name is the same as original workout name and '
    'stages are the same as original stages, '
    'should be true',
    () {
      state = state.copyWith(
        date: DateTime(2023, 2, 2),
        workout: createWorkout(
          name: 'workout name',
          stages: [
            WorkoutStageBaseRun(
              distanceInKilometers: 10,
              maxHeartRate: 150,
            ),
            WorkoutStageZone2(
              distanceInKilometers: 3,
              maxHeartRate: 165,
            ),
          ],
        ),
        workoutName: 'workout name',
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 10,
            maxHeartRate: 150,
          ),
          WorkoutStageZone2(
            distanceInKilometers: 3,
            maxHeartRate: 165,
          ),
        ],
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is button disabled, '
    'workout is null, '
    'date and workout name are not null and workout stages list is not empty, '
    'should be false',
    () {
      state = state.copyWith(
        date: DateTime(2023, 2, 2),
        workoutName: 'workout name',
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 10,
            maxHeartRate: 150,
          ),
        ],
      );

      expect(state.isSubmitButtonDisabled, false);
    },
  );

  test(
    'is button disabled, '
    'workout is not null, '
    'workout name is different than the original workout name, '
    'should be false',
    () {
      state = state.copyWith(
        date: DateTime(2023, 2, 2),
        workout: createWorkout(
          name: 'workout 1',
          stages: [
            WorkoutStageBaseRun(
              distanceInKilometers: 10,
              maxHeartRate: 150,
            ),
          ],
        ),
        workoutName: 'workout name',
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 10,
            maxHeartRate: 150,
          ),
        ],
      );

      expect(state.isSubmitButtonDisabled, false);
    },
  );

  test(
    'is button disabled, '
    'workout is not null, '
    'workout stages are different than the original workout stages, '
    'should be false',
    () {
      state = state.copyWith(
        date: DateTime(2023, 2, 2),
        workout: createWorkout(
          name: 'workout 1',
          stages: [
            WorkoutStageBaseRun(
              distanceInKilometers: 10,
              maxHeartRate: 150,
            ),
            WorkoutStageZone2(
              distanceInKilometers: 2,
              maxHeartRate: 165,
            ),
          ],
        ),
        workoutName: 'workout 1',
        stages: [
          WorkoutStageZone2(
            distanceInKilometers: 2,
            maxHeartRate: 165,
          ),
          WorkoutStageBaseRun(
            distanceInKilometers: 10,
            maxHeartRate: 150,
          ),
        ],
      );

      expect(state.isSubmitButtonDisabled, false);
    },
  );

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
    'copy with workout',
    () {
      final Workout expectedWorkout = createWorkout(id: 'w1');

      state = state.copyWith(workout: expectedWorkout);
      final state2 = state.copyWith();

      expect(state.workout, expectedWorkout);
      expect(state2.workout, expectedWorkout);
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
