import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/workout_creator/workout_creator_bloc.dart';
import 'package:runnoter/domain/entity/run_status.dart';
import 'package:runnoter/domain/entity/workout.dart';
import 'package:runnoter/domain/entity/workout_stage.dart';

import '../../../creators/workout_creator.dart';
import '../../../mock/domain/repository/mock_workout_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();

  WorkoutCreatorBloc createBloc({
    DateTime? date,
    Workout? workout,
    String? workoutName,
    List<WorkoutStage> stages = const [],
  }) =>
      WorkoutCreatorBloc(
        authService: authService,
        workoutRepository: workoutRepository,
        date: date,
        workout: workout,
        workoutName: workoutName,
        stages: stages,
      );

  WorkoutCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
    Workout? workout,
    String? workoutName,
    List<WorkoutStage> stages = const [],
  }) =>
      WorkoutCreatorState(
        status: status,
        date: date,
        workout: workout,
        workoutName: workoutName,
        stages: stages,
      );

  tearDown(() {
    reset(authService);
    reset(workoutRepository);
  });

  blocTest(
    'initialize, '
    'workout id is null, '
    'should only update date in state',
    build: () => createBloc(),
    act: (WorkoutCreatorBloc bloc) => bloc.add(
      WorkoutCreatorEventInitialize(
        date: DateTime(2023, 1, 1),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        date: DateTime(2023, 1, 1),
      ),
    ],
  );

  blocTest(
    'initialize, '
    'workout id is not null, '
    'logged user does not exist, '
    'should only update date in state',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (WorkoutCreatorBloc bloc) => bloc.add(
      WorkoutCreatorEventInitialize(
        date: DateTime(2023, 1, 1),
        workoutId: 'w1',
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        date: DateTime(2023, 1, 1),
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'workout id is not null, '
    'logged user exists, '
    'should load workout matching to given id and should emit updated date, workout, workout name and stages',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockGetWorkoutById(
        workout: createWorkout(
          id: 'w1',
          name: 'workout name',
          stages: [
            WorkoutStageBaseRun(
              distanceInKilometers: 10,
              maxHeartRate: 150,
            ),
          ],
        ),
      );
    },
    act: (WorkoutCreatorBloc bloc) => bloc.add(
      WorkoutCreatorEventInitialize(
        date: DateTime(2023, 1, 1),
        workoutId: 'w1',
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete<WorkoutCreatorBlocInfo>(
          info: WorkoutCreatorBlocInfo.editModeInitialized,
        ),
        date: DateTime(2023, 1, 1),
        workout: createWorkout(
          id: 'w1',
          name: 'workout name',
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
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getWorkoutById(
          workoutId: 'w1',
          userId: 'u1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'workout name changed, '
    'should update workout name in state',
    build: () => createBloc(),
    act: (WorkoutCreatorBloc bloc) => bloc.add(
      const WorkoutCreatorEventWorkoutNameChanged(
        workoutName: 'new workout name',
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        workoutName: 'new workout name',
      ),
    ],
  );

  blocTest(
    'workout stage added, '
    'should add workout stage to existing stages',
    build: () => createBloc(
      stages: [
        WorkoutStageBaseRun(
          distanceInKilometers: 2,
          maxHeartRate: 150,
        ),
      ],
    ),
    act: (WorkoutCreatorBloc bloc) => bloc.add(
      WorkoutCreatorEventWorkoutStageAdded(
        workoutStage: WorkoutStageZone2(
          distanceInKilometers: 5,
          maxHeartRate: 165,
        ),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 2,
            maxHeartRate: 150,
          ),
          WorkoutStageZone2(
            distanceInKilometers: 5,
            maxHeartRate: 165,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'workout stages order changed, '
    'should update list of workout stages in state',
    build: () => createBloc(
      stages: [
        WorkoutStageBaseRun(
          distanceInKilometers: 1,
          maxHeartRate: 150,
        ),
        WorkoutStageZone2(
          distanceInKilometers: 3,
          maxHeartRate: 165,
        ),
        WorkoutStageBaseRun(
          distanceInKilometers: 3,
          maxHeartRate: 150,
        ),
        WorkoutStageZone3(
          distanceInKilometers: 2,
          maxHeartRate: 180,
        ),
      ],
    ),
    act: (WorkoutCreatorBloc bloc) => bloc.add(
      WorkoutCreatorEventWorkoutStagesOrderChanged(
        workoutStages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 3,
            maxHeartRate: 150,
          ),
          WorkoutStageZone3(
            distanceInKilometers: 2,
            maxHeartRate: 180,
          ),
          WorkoutStageBaseRun(
            distanceInKilometers: 1,
            maxHeartRate: 150,
          ),
          WorkoutStageZone2(
            distanceInKilometers: 3,
            maxHeartRate: 165,
          ),
        ],
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 3,
            maxHeartRate: 150,
          ),
          WorkoutStageZone3(
            distanceInKilometers: 2,
            maxHeartRate: 180,
          ),
          WorkoutStageBaseRun(
            distanceInKilometers: 1,
            maxHeartRate: 150,
          ),
          WorkoutStageZone2(
            distanceInKilometers: 3,
            maxHeartRate: 165,
          ),
        ],
      )
    ],
  );

  blocTest(
    'delete workout stage, '
    'should delete workout stage by its index',
    build: () => createBloc(
      stages: [
        WorkoutStageZone2(
          distanceInKilometers: 5,
          maxHeartRate: 165,
        ),
        WorkoutStageBaseRun(
          distanceInKilometers: 15,
          maxHeartRate: 150,
        ),
      ],
    ),
    act: (WorkoutCreatorBloc bloc) => bloc.add(
      const WorkoutCreatorEventDeleteWorkoutStage(index: 0),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 15,
            maxHeartRate: 150,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'submit, '
    'date is not set, '
    'should finish event call',
    build: () => createBloc(
      workoutName: 'workout 1',
      stages: [
        WorkoutStageBaseRun(
          distanceInKilometers: 4,
          maxHeartRate: 150,
        ),
        WorkoutStageZone3(
          distanceInKilometers: 2,
          maxHeartRate: 180,
        ),
      ],
    ),
    act: (WorkoutCreatorBloc bloc) => bloc.add(
      const WorkoutCreatorEventSubmit(),
    ),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'workout name is not set, '
    'should finish event call',
    build: () => createBloc(
      date: DateTime(2023, 2, 2),
      stages: [
        WorkoutStageBaseRun(
          distanceInKilometers: 4,
          maxHeartRate: 150,
        ),
        WorkoutStageZone3(
          distanceInKilometers: 2,
          maxHeartRate: 180,
        ),
      ],
    ),
    act: (WorkoutCreatorBloc bloc) => bloc.add(
      const WorkoutCreatorEventSubmit(),
    ),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'no workout stages, '
    'should finish event call',
    build: () => createBloc(
      date: DateTime(2023, 2, 2),
      workoutName: 'workout 1',
    ),
    act: (WorkoutCreatorBloc bloc) => bloc.add(
      const WorkoutCreatorEventSubmit(),
    ),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'logged user does not exist, should finish event call',
    build: () => createBloc(
      date: DateTime(2023, 2, 2),
      workoutName: 'workout 1',
      stages: [
        WorkoutStageBaseRun(
          distanceInKilometers: 4,
          maxHeartRate: 150,
        ),
        WorkoutStageZone3(
          distanceInKilometers: 2,
          maxHeartRate: 180,
        ),
      ],
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (WorkoutCreatorBloc bloc) => bloc.add(
      const WorkoutCreatorEventSubmit(),
    ),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'submit, '
    'workout is null, '
    "should call workout repository's method to add workout with pending status and should emit info that workout has been added",
    build: () => createBloc(
      date: DateTime(2023, 2, 2),
      workoutName: 'workout 1',
      stages: [
        WorkoutStageBaseRun(
          distanceInKilometers: 4,
          maxHeartRate: 150,
        ),
        WorkoutStageZone3(
          distanceInKilometers: 2,
          maxHeartRate: 180,
        ),
      ],
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockAddWorkout();
    },
    act: (WorkoutCreatorBloc bloc) => bloc.add(
      const WorkoutCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        date: DateTime(2023, 2, 2),
        workoutName: 'workout 1',
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 4,
            maxHeartRate: 150,
          ),
          WorkoutStageZone3(
            distanceInKilometers: 2,
            maxHeartRate: 180,
          ),
        ],
      ),
      createState(
        status: const BlocStatusComplete<WorkoutCreatorBlocInfo>(
          info: WorkoutCreatorBlocInfo.workoutAdded,
        ),
        date: DateTime(2023, 2, 2),
        workoutName: 'workout 1',
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 4,
            maxHeartRate: 150,
          ),
          WorkoutStageZone3(
            distanceInKilometers: 2,
            maxHeartRate: 180,
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.addWorkout(
          userId: 'u1',
          workoutName: 'workout 1',
          date: DateTime(2023, 2, 2),
          status: const RunStatusPending(),
          stages: [
            WorkoutStageBaseRun(
              distanceInKilometers: 4,
              maxHeartRate: 150,
            ),
            WorkoutStageZone3(
              distanceInKilometers: 2,
              maxHeartRate: 180,
            ),
          ],
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'workout is not null, '
    "should call workout repository's method to update workout and should emit info that workout has been updated",
    build: () => createBloc(
      date: DateTime(2023, 2, 2),
      workout: createWorkout(
        id: 'w1',
        name: 'workout name',
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 10,
            maxHeartRate: 150,
          ),
        ],
      ),
      workoutName: 'workout 1',
      stages: [
        WorkoutStageBaseRun(
          distanceInKilometers: 4,
          maxHeartRate: 150,
        ),
        WorkoutStageZone3(
          distanceInKilometers: 2,
          maxHeartRate: 180,
        ),
      ],
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockUpdateWorkout();
    },
    act: (WorkoutCreatorBloc bloc) => bloc.add(
      const WorkoutCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        date: DateTime(2023, 2, 2),
        workout: createWorkout(
          id: 'w1',
          name: 'workout name',
          stages: [
            WorkoutStageBaseRun(
              distanceInKilometers: 10,
              maxHeartRate: 150,
            ),
          ],
        ),
        workoutName: 'workout 1',
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 4,
            maxHeartRate: 150,
          ),
          WorkoutStageZone3(
            distanceInKilometers: 2,
            maxHeartRate: 180,
          ),
        ],
      ),
      createState(
        status: const BlocStatusComplete<WorkoutCreatorBlocInfo>(
          info: WorkoutCreatorBlocInfo.workoutUpdated,
        ),
        date: DateTime(2023, 2, 2),
        workout: createWorkout(
          id: 'w1',
          name: 'workout name',
          stages: [
            WorkoutStageBaseRun(
              distanceInKilometers: 10,
              maxHeartRate: 150,
            ),
          ],
        ),
        workoutName: 'workout 1',
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 4,
            maxHeartRate: 150,
          ),
          WorkoutStageZone3(
            distanceInKilometers: 2,
            maxHeartRate: 180,
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.updateWorkout(
          workoutId: 'w1',
          userId: 'u1',
          workoutName: 'workout 1',
          stages: [
            WorkoutStageBaseRun(
              distanceInKilometers: 4,
              maxHeartRate: 150,
            ),
            WorkoutStageZone3(
              distanceInKilometers: 2,
              maxHeartRate: 180,
            ),
          ],
        ),
      ).called(1);
    },
  );
}
