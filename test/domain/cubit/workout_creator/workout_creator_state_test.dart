import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/workout_stage.dart';
import 'package:runnoter/domain/cubit/workout_creator/workout_creator_cubit.dart';
import 'package:runnoter/domain/entity/workout.dart';

import '../../../creators/workout_creator.dart';
import '../../../mock/common/mock_date_service.dart';

void main() {
  final dateService = MockDateService();
  late WorkoutCreatorState state;

  setUp(() {
    state = WorkoutCreatorState(
      dateService: dateService,
      status: const BlocStatusInitial(),
      stages: const [],
    );
    dateService.mockAreDatesTheSame(expected: true);
  });

  tearDown(() {
    reset(dateService);
  });

  test(
    'can submit, '
    'date is null, '
    'should be false',
    () {
      state = state.copyWith(
        status: const BlocStatusComplete(),
        workoutName: 'workout name',
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
    'workout name is null, '
    'should be false',
    () {
      state = state.copyWith(
        status: const BlocStatusComplete(),
        date: DateTime(2023),
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
        status: const BlocStatusComplete(),
        date: DateTime(2023),
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
        status: const BlocStatusComplete(),
        date: DateTime(2023),
        workoutName: 'workout name',
        stages: const [],
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'date is the same as original date, '
    'workout name is the same as original workout name and '
    'stages are the same as original stages, '
    'should be false',
    () {
      state = state.copyWith(
        status: const BlocStatusComplete(),
        date: DateTime(2023),
        workout: createWorkout(
          name: 'workout name',
          date: DateTime(2023),
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
        status: const BlocStatusComplete(),
        date: DateTime(2023),
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
    'date is different than the original workout date, '
    'should be true',
    () {
      dateService.mockAreDatesTheSame(expected: false);
      state = state.copyWith(
        status: const BlocStatusComplete(),
        date: DateTime(2023, 2, 1),
        workout: createWorkout(
          date: DateTime(2023),
          name: 'workout 1',
          stages: const [
            WorkoutStageCardio(
              distanceInKm: 10,
              maxHeartRate: 150,
            ),
          ],
        ),
        workoutName: 'workout 1',
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
        status: const BlocStatusComplete(),
        date: DateTime(2023),
        workout: createWorkout(
          date: DateTime(2023),
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
        status: const BlocStatusComplete(),
        date: DateTime(2023),
        workout: createWorkout(
          date: DateTime(2023),
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
    'copy with status, '
    'should set complete status if new value is null',
    () {
      const BlocStatus expectedStatus = BlocStatusInitial();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with date, '
    'should copy current value if new value is null',
    () {
      final DateTime expectedDate = DateTime(2023);

      state = state.copyWith(date: expectedDate);
      final state2 = state.copyWith();

      expect(state.date, expectedDate);
      expect(state2.date, expectedDate);
    },
  );

  test(
    'copy with workout, '
    'should copy current value if new value is null',
    () {
      final Workout expectedWorkout = createWorkout(id: 'w1');

      state = state.copyWith(workout: expectedWorkout);
      final state2 = state.copyWith();

      expect(state.workout, expectedWorkout);
      expect(state2.workout, expectedWorkout);
    },
  );

  test(
    'copy with workout name, '
    'should copy current value if new value is null',
    () {
      const String expectedName = 'workoutName';

      state = state.copyWith(workoutName: expectedName);
      final state2 = state.copyWith();

      expect(state.workoutName, expectedName);
      expect(state2.workoutName, expectedName);
    },
  );
}
