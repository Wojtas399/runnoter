import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/data/additional_model/custom_exception.dart';
import 'package:runnoter/data/entity/activity.dart';
import 'package:runnoter/data/entity/workout.dart';
import 'package:runnoter/data/interface/repository/workout_repository.dart';
import 'package:runnoter/ui/cubit/workout_creator/workout_creator_cubit.dart';
import 'package:runnoter/ui/model/cubit_status.dart';

import '../../../creators/workout_creator.dart';
import '../../../mock/common/mock_date_service.dart';
import '../../../mock/domain/repository/mock_workout_repository.dart';

void main() {
  final workoutRepository = MockWorkoutRepository();
  final dateService = MockDateService();
  const String userId = 'u1';
  const String workoutId = 'w1';

  WorkoutCreatorCubit createCubit({
    String? workoutId,
    DateTime? date,
    Workout? workout,
    String? workoutName,
    List<WorkoutStage> stages = const [],
  }) =>
      WorkoutCreatorCubit(
        userId: userId,
        workoutId: workoutId,
        date: date,
        workout: workout,
        workoutName: workoutName,
        stages: stages,
      );

  WorkoutCreatorState createState({
    CubitStatus status = const CubitStatusInitial(),
    DateTime? date,
    Workout? workout,
    String? workoutName,
    List<WorkoutStage> stages = const [],
  }) =>
      WorkoutCreatorState(
        dateService: dateService,
        status: status,
        date: date,
        workout: workout,
        workoutName: workoutName,
        stages: stages,
      );

  setUpAll(() {
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
    GetIt.I.registerFactory<DateService>(() => dateService);
  });

  tearDown(() {
    reset(workoutRepository);
    reset(dateService);
  });

  blocTest(
    'initialize, '
    'workout id is null, '
    'should emit complete status',
    build: () => createCubit(),
    act: (cubit) => cubit.initialize(),
    expect: () => [
      createState(
        status: const CubitStatusComplete(),
      ),
    ],
  );

  blocTest(
    'initialize, '
    'workout id is not null, '
    'should load workout matching to given id, '
    'should emit updated date, workout, workout name and stages',
    build: () => createCubit(workoutId: workoutId),
    setUp: () => workoutRepository.mockGetWorkoutById(
      workout: createWorkout(
        id: workoutId,
        date: DateTime(2023, 2, 4),
        name: 'workout name',
        stages: const [
          WorkoutStageCardio(distanceInKm: 10, maxHeartRate: 150),
        ],
      ),
    ),
    act: (cubit) => cubit.initialize(),
    expect: () => [
      createState(
        status: const CubitStatusComplete(),
        date: DateTime(2023, 2, 4),
        workout: createWorkout(
          id: workoutId,
          date: DateTime(2023, 2, 4),
          name: 'workout name',
          stages: const [
            WorkoutStageCardio(distanceInKm: 10, maxHeartRate: 150),
          ],
        ),
        workoutName: 'workout name',
        stages: const [
          WorkoutStageCardio(distanceInKm: 10, maxHeartRate: 150),
        ],
      ),
    ],
    verify: (_) => verify(
      () => workoutRepository.getWorkoutById(
        workoutId: workoutId,
        userId: userId,
      ),
    ).called(1),
  );

  blocTest(
    'dateChanged, '
    'should update date in state',
    build: () => createCubit(),
    act: (cubit) => cubit.dateChanged(DateTime(2023, 2, 2)),
    expect: () => [
      createState(
        status: const CubitStatusComplete(),
        date: DateTime(2023, 2, 2),
      ),
    ],
  );

  blocTest(
    'workoutNameChanged, '
    'should update workout name in state',
    build: () => createCubit(),
    act: (cubit) => cubit.workoutNameChanged('new workout name'),
    expect: () => [
      createState(
        status: const CubitStatusComplete(),
        workoutName: 'new workout name',
      ),
    ],
  );

  blocTest(
    'workoutStageAdded, '
    'should add workout stage to existing stages',
    build: () => createCubit(
      stages: const [
        WorkoutStageCardio(distanceInKm: 2, maxHeartRate: 150),
      ],
    ),
    act: (cubit) => cubit.workoutStageAdded(
      const WorkoutStageZone2(distanceInKm: 5, maxHeartRate: 165),
    ),
    expect: () => [
      createState(
        status: const CubitStatusComplete(),
        stages: const [
          WorkoutStageCardio(distanceInKm: 2, maxHeartRate: 150),
          WorkoutStageZone2(distanceInKm: 5, maxHeartRate: 165),
        ],
      ),
    ],
  );

  blocTest(
    'updateWorkoutStageAtIndex, '
    'list of stages is empty, '
    'should do nothing',
    build: () => createCubit(stages: const []),
    act: (cubit) => cubit.updateWorkoutStageAtIndex(
      stageIndex: 1,
      updatedStage: const WorkoutStageZone2(distanceInKm: 7, maxHeartRate: 160),
    ),
    expect: () => [],
  );

  blocTest(
    'updateWorkoutStageAtIndex, '
    'length of list of stages is lower than given stage index, '
    'should do nothing',
    build: () => createCubit(
      stages: const [
        WorkoutStageCardio(distanceInKm: 2, maxHeartRate: 150),
      ],
    ),
    act: (cubit) => cubit.updateWorkoutStageAtIndex(
      stageIndex: 1,
      updatedStage: const WorkoutStageZone2(distanceInKm: 7, maxHeartRate: 160),
    ),
    expect: () => [],
  );

  blocTest(
    'updateWorkoutStageAtIndex, '
    'should update workout stage at given index',
    build: () => createCubit(
      stages: const [
        WorkoutStageCardio(distanceInKm: 2, maxHeartRate: 150),
        WorkoutStageZone2(distanceInKm: 5, maxHeartRate: 165),
      ],
    ),
    act: (cubit) => cubit.updateWorkoutStageAtIndex(
      stageIndex: 1,
      updatedStage: const WorkoutStageZone2(distanceInKm: 7, maxHeartRate: 160),
    ),
    expect: () => [
      createState(
        status: const CubitStatusComplete(),
        stages: const [
          WorkoutStageCardio(distanceInKm: 2, maxHeartRate: 150),
          WorkoutStageZone2(distanceInKm: 7, maxHeartRate: 160),
        ],
      ),
    ],
  );

  blocTest(
    'workoutStagesOrderChanged, '
    'should update list of workout stages in state',
    build: () => createCubit(
      stages: const [
        WorkoutStageCardio(distanceInKm: 1, maxHeartRate: 150),
        WorkoutStageZone2(distanceInKm: 3, maxHeartRate: 165),
        WorkoutStageCardio(distanceInKm: 3, maxHeartRate: 150),
        WorkoutStageZone3(distanceInKm: 2, maxHeartRate: 180),
      ],
    ),
    act: (cubit) => cubit.workoutStagesOrderChanged(
      const [
        WorkoutStageCardio(distanceInKm: 3, maxHeartRate: 150),
        WorkoutStageZone3(distanceInKm: 2, maxHeartRate: 180),
        WorkoutStageCardio(distanceInKm: 1, maxHeartRate: 150),
        WorkoutStageZone2(distanceInKm: 3, maxHeartRate: 165),
      ],
    ),
    expect: () => [
      createState(
        status: const CubitStatusComplete(),
        stages: const [
          WorkoutStageCardio(distanceInKm: 3, maxHeartRate: 150),
          WorkoutStageZone3(distanceInKm: 2, maxHeartRate: 180),
          WorkoutStageCardio(distanceInKm: 1, maxHeartRate: 150),
          WorkoutStageZone2(distanceInKm: 3, maxHeartRate: 165),
        ],
      )
    ],
  );

  blocTest(
    'deleteWorkoutStageAtIndex, '
    'should delete workout stage by its index',
    build: () => createCubit(
      stages: const [
        WorkoutStageZone2(distanceInKm: 5, maxHeartRate: 165),
        WorkoutStageCardio(distanceInKm: 15, maxHeartRate: 150),
      ],
    ),
    act: (cubit) => cubit.deleteWorkoutStageAtIndex(0),
    expect: () => [
      createState(
        status: const CubitStatusComplete(),
        stages: const [
          WorkoutStageCardio(distanceInKm: 15, maxHeartRate: 150),
        ],
      ),
    ],
  );

  blocTest(
    'submit, '
    'workout name is not set, '
    'should finish event call',
    build: () => createCubit(
      date: DateTime(2023, 2, 2),
      stages: const [
        WorkoutStageCardio(distanceInKm: 4, maxHeartRate: 150),
        WorkoutStageZone3(distanceInKm: 2, maxHeartRate: 180),
      ],
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'list of workout stage is empty, '
    'should finish event call',
    build: () => createCubit(
      date: DateTime(2023, 2, 2),
      workoutName: 'workout 1',
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'workout is null, '
    'should call workout repository method to add workout with pending status, '
    'should emit info that workout has been added',
    build: () => createCubit(
      date: DateTime(2023, 2, 2),
      workoutName: 'workout 1',
      stages: const [
        WorkoutStageCardio(distanceInKm: 4, maxHeartRate: 150),
        WorkoutStageZone3(distanceInKm: 2, maxHeartRate: 180),
      ],
    ),
    setUp: () => workoutRepository.mockAddWorkout(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      createState(
        status: const CubitStatusLoading(),
        date: DateTime(2023, 2, 2),
        workoutName: 'workout 1',
        stages: const [
          WorkoutStageCardio(distanceInKm: 4, maxHeartRate: 150),
          WorkoutStageZone3(distanceInKm: 2, maxHeartRate: 180),
        ],
      ),
      createState(
        status: const CubitStatusComplete<WorkoutCreatorCubitInfo>(
          info: WorkoutCreatorCubitInfo.workoutAdded,
        ),
        date: DateTime(2023, 2, 2),
        workoutName: 'workout 1',
        stages: const [
          WorkoutStageCardio(distanceInKm: 4, maxHeartRate: 150),
          WorkoutStageZone3(distanceInKm: 2, maxHeartRate: 180),
        ],
      ),
    ],
    verify: (_) => verify(
      () => workoutRepository.addWorkout(
        userId: userId,
        workoutName: 'workout 1',
        date: DateTime(2023, 2, 2),
        status: const ActivityStatusPending(),
        stages: const [
          WorkoutStageCardio(distanceInKm: 4, maxHeartRate: 150),
          WorkoutStageZone3(distanceInKm: 2, maxHeartRate: 180),
        ],
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'workout is not null, '
    'should call workout repository method to update workout, '
    'should emit info that workout has been updated',
    build: () => createCubit(
      workoutId: workoutId,
      date: DateTime(2023, 2, 2),
      workout: createWorkout(
        id: workoutId,
        date: DateTime(2023, 2, 10),
        name: 'workout name',
        stages: const [
          WorkoutStageCardio(distanceInKm: 10, maxHeartRate: 150),
        ],
      ),
      workoutName: 'workout 1',
      stages: const [
        WorkoutStageCardio(distanceInKm: 4, maxHeartRate: 150),
        WorkoutStageZone3(distanceInKm: 2, maxHeartRate: 180),
      ],
    ),
    setUp: () {
      dateService.mockAreDaysTheSame(expected: false);
      workoutRepository.mockUpdateWorkout();
    },
    act: (cubit) => cubit.submit(),
    expect: () => [
      createState(
        status: const CubitStatusLoading(),
        date: DateTime(2023, 2, 2),
        workout: createWorkout(
          id: workoutId,
          date: DateTime(2023, 2, 10),
          name: 'workout name',
          stages: const [
            WorkoutStageCardio(distanceInKm: 10, maxHeartRate: 150),
          ],
        ),
        workoutName: 'workout 1',
        stages: const [
          WorkoutStageCardio(distanceInKm: 4, maxHeartRate: 150),
          WorkoutStageZone3(distanceInKm: 2, maxHeartRate: 180),
        ],
      ),
      createState(
        status: const CubitStatusComplete<WorkoutCreatorCubitInfo>(
          info: WorkoutCreatorCubitInfo.workoutUpdated,
        ),
        date: DateTime(2023, 2, 2),
        workout: createWorkout(
          id: workoutId,
          date: DateTime(2023, 2, 10),
          name: 'workout name',
          stages: const [
            WorkoutStageCardio(distanceInKm: 10, maxHeartRate: 150),
          ],
        ),
        workoutName: 'workout 1',
        stages: const [
          WorkoutStageCardio(distanceInKm: 4, maxHeartRate: 150),
          WorkoutStageZone3(distanceInKm: 2, maxHeartRate: 180),
        ],
      ),
    ],
    verify: (_) => verify(
      () => workoutRepository.updateWorkout(
        workoutId: workoutId,
        userId: userId,
        date: DateTime(2023, 2, 2),
        workoutName: 'workout 1',
        stages: const [
          WorkoutStageCardio(distanceInKm: 4, maxHeartRate: 150),
          WorkoutStageZone3(distanceInKm: 2, maxHeartRate: 180),
        ],
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'workout is not null, '
    'workout repository method to update workout throws entity exception '
    'with entityNotFound code'
    'should emit error status with workoutNoLongerExists error',
    build: () => createCubit(
      workoutId: workoutId,
      date: DateTime(2023, 2, 2),
      workout: createWorkout(
        id: workoutId,
        date: DateTime(2023, 2, 10),
        name: 'workout name',
        stages: const [
          WorkoutStageCardio(distanceInKm: 10, maxHeartRate: 150),
        ],
      ),
      workoutName: 'workout 1',
      stages: const [
        WorkoutStageCardio(distanceInKm: 4, maxHeartRate: 150),
        WorkoutStageZone3(distanceInKm: 2, maxHeartRate: 180),
      ],
    ),
    setUp: () {
      dateService.mockAreDaysTheSame(expected: false);
      workoutRepository.mockUpdateWorkout(
        throwable: const EntityException(
          code: EntityExceptionCode.entityNotFound,
        ),
      );
    },
    act: (cubit) => cubit.submit(),
    expect: () => [
      createState(
        status: const CubitStatusLoading(),
        date: DateTime(2023, 2, 2),
        workout: createWorkout(
          id: workoutId,
          date: DateTime(2023, 2, 10),
          name: 'workout name',
          stages: const [
            WorkoutStageCardio(distanceInKm: 10, maxHeartRate: 150),
          ],
        ),
        workoutName: 'workout 1',
        stages: const [
          WorkoutStageCardio(distanceInKm: 4, maxHeartRate: 150),
          WorkoutStageZone3(distanceInKm: 2, maxHeartRate: 180),
        ],
      ),
      createState(
        status: const CubitStatusError<WorkoutCreatorCubitError>(
          error: WorkoutCreatorCubitError.workoutNoLongerExists,
        ),
        date: DateTime(2023, 2, 2),
        workout: createWorkout(
          id: workoutId,
          date: DateTime(2023, 2, 10),
          name: 'workout name',
          stages: const [
            WorkoutStageCardio(distanceInKm: 10, maxHeartRate: 150),
          ],
        ),
        workoutName: 'workout 1',
        stages: const [
          WorkoutStageCardio(distanceInKm: 4, maxHeartRate: 150),
          WorkoutStageZone3(distanceInKm: 2, maxHeartRate: 180),
        ],
      ),
    ],
    verify: (_) => verify(
      () => workoutRepository.updateWorkout(
        workoutId: workoutId,
        userId: userId,
        date: DateTime(2023, 2, 2),
        workoutName: 'workout 1',
        stages: const [
          WorkoutStageCardio(distanceInKm: 4, maxHeartRate: 150),
          WorkoutStageZone3(distanceInKm: 2, maxHeartRate: 180),
        ],
      ),
    ).called(1),
  );
}
