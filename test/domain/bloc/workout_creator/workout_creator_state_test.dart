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
      workout: null,
      workoutName: null,
      stages: [],
    );
  });

  test(
    'can submit, '
    'workout name is null, '
    'should be false',
    () {
      state = state.copyWith(
        stages: const [
          WorkoutStageCardio(
            distanceInKm: 10,
            maxHeartRate: 150,
          ),
        ],
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'workout name is empty, '
    'should be false',
    () {
      state = state.copyWith(
        workoutName: '',
        stages: const [
          WorkoutStageCardio(
            distanceInKm: 10,
            maxHeartRate: 150,
          ),
        ],
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'workout stages list is empty, '
    'should be false',
    () {
      state = state.copyWith(
        workoutName: 'workout name',
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'workout name is the same as original workout name and '
    'stages are the same as original stages, '
    'should be false',
    () {
      state = state.copyWith(
        workout: createWorkout(
          name: 'workout name',
          stages: const [
            WorkoutStageCardio(
              distanceInKm: 10,
              maxHeartRate: 150,
            ),
            WorkoutStageZone2(
              distanceInKm: 3,
              maxHeartRate: 165,
            ),
          ],
        ),
        workoutName: 'workout name',
        stages: const [
          WorkoutStageCardio(
            distanceInKm: 10,
            maxHeartRate: 150,
          ),
          WorkoutStageZone2(
            distanceInKm: 3,
            maxHeartRate: 165,
          ),
        ],
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'workout is null, '
    'date and workout name are not null and workout stages list is not empty, '
    'should be true',
    () {
      state = state.copyWith(
        workoutName: 'workout name',
        stages: const [
          WorkoutStageCardio(
            distanceInKm: 10,
            maxHeartRate: 150,
          ),
        ],
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'workout is not null, '
    'workout name is different than the original workout name, '
    'should be true',
    () {
      state = state.copyWith(
        workout: createWorkout(
          name: 'workout 1',
          stages: const [
            WorkoutStageCardio(
              distanceInKm: 10,
              maxHeartRate: 150,
            ),
          ],
        ),
        workoutName: 'workout name',
        stages: const [
          WorkoutStageCardio(
            distanceInKm: 10,
            maxHeartRate: 150,
          ),
        ],
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'workout is not null, '
    'workout stages are different than the original workout stages, '
    'should be true',
    () {
      state = state.copyWith(
        workout: createWorkout(
          name: 'workout 1',
          stages: const [
            WorkoutStageCardio(
              distanceInKm: 10,
              maxHeartRate: 150,
            ),
            WorkoutStageZone2(
              distanceInKm: 2,
              maxHeartRate: 165,
            ),
          ],
        ),
        workoutName: 'workout 1',
        stages: const [
          WorkoutStageZone2(
            distanceInKm: 2,
            maxHeartRate: 165,
          ),
          WorkoutStageCardio(
            distanceInKm: 10,
            maxHeartRate: 150,
          ),
        ],
      );

      expect(state.canSubmit, true);
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
}
