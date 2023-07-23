import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/workout_creator/workout_creator_bloc.dart';
import 'package:runnoter/domain/entity/run_status.dart';
import 'package:runnoter/domain/entity/workout.dart';
import 'package:runnoter/domain/entity/workout_stage.dart';
import 'package:runnoter/domain/repository/workout_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../creators/workout_creator.dart';
import '../../../mock/domain/repository/mock_workout_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();
  const String loggedUserId = 'u1';
  const String workoutId = 'w1';

  WorkoutCreatorBloc createBloc({
    String? workoutId,
    DateTime? date,
    Workout? workout,
    String? workoutName,
    List<WorkoutStage> stages = const [],
  }) =>
      WorkoutCreatorBloc(
        date: date ?? DateTime(2023),
        workoutId: workoutId,
        state: WorkoutCreatorState(
          status: const BlocStatusInitial(),
          workout: workout,
          workoutName: workoutName,
          stages: stages,
        ),
      );

  WorkoutCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    Workout? workout,
    String? workoutName,
    List<WorkoutStage> stages = const [],
  }) =>
      WorkoutCreatorState(
        status: status,
        workout: workout,
        workoutName: workoutName,
        stages: stages,
      );

  setUpAll(() {
    GetIt.I.registerSingleton<AuthService>(authService);
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
  });

  tearDown(() {
    reset(authService);
    reset(workoutRepository);
  });

  blocTest(
    'initialize, '
    'workout id is null, '
    'should emit complete status',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const WorkoutCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
      ),
    ],
  );

  blocTest(
    'initialize, '
    'workout id is not null, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createBloc(workoutId: workoutId),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const WorkoutCreatorEventInitialize()),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'workout id is not null, '
    'logged user exists, '
    'should load workout matching to given id and should emit updated date, workout, workout name and stages',
    build: () => createBloc(workoutId: workoutId),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockGetWorkoutById(
        workout: createWorkout(
          id: workoutId,
          name: 'workout name',
          stages: const [
            WorkoutStageCardio(
              distanceInKm: 10,
              maxHeartRate: 150,
            ),
          ],
        ),
      );
    },
    act: (bloc) => bloc.add(const WorkoutCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete<WorkoutCreatorBlocInfo>(
          info: WorkoutCreatorBlocInfo.editModeInitialized,
        ),
        workout: createWorkout(
          id: workoutId,
          name: 'workout name',
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
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getWorkoutById(
          workoutId: workoutId,
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'workout name changed, '
    'should update workout name in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const WorkoutCreatorEventWorkoutNameChanged(
      workoutName: 'new workout name',
    )),
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
      stages: const [
        WorkoutStageCardio(
          distanceInKm: 2,
          maxHeartRate: 150,
        ),
      ],
    ),
    act: (bloc) => bloc.add(const WorkoutCreatorEventWorkoutStageAdded(
      workoutStage: WorkoutStageZone2(
        distanceInKm: 5,
        maxHeartRate: 165,
      ),
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        stages: const [
          WorkoutStageCardio(
            distanceInKm: 2,
            maxHeartRate: 150,
          ),
          WorkoutStageZone2(
            distanceInKm: 5,
            maxHeartRate: 165,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'workout stage updated, '
    'list of stages is empty, '
    'should do nothing',
    build: () => createBloc(stages: const []),
    act: (bloc) => bloc.add(const WorkoutCreatorEventWorkoutStageUpdated(
      stageIndex: 1,
      workoutStage: WorkoutStageZone2(
        distanceInKm: 7,
        maxHeartRate: 160,
      ),
    )),
    expect: () => [],
  );

  blocTest(
    'workout stage updated, '
    'length of list of stages is lower than given stage index, '
    'should do nothing',
    build: () => createBloc(
      stages: const [
        WorkoutStageCardio(
          distanceInKm: 2,
          maxHeartRate: 150,
        ),
      ],
    ),
    act: (bloc) => bloc.add(const WorkoutCreatorEventWorkoutStageUpdated(
      stageIndex: 1,
      workoutStage: WorkoutStageZone2(
        distanceInKm: 7,
        maxHeartRate: 160,
      ),
    )),
    expect: () => [],
  );

  blocTest(
    'workout stage updated, '
    'should update workout stage at given index',
    build: () => createBloc(
      stages: const [
        WorkoutStageCardio(
          distanceInKm: 2,
          maxHeartRate: 150,
        ),
        WorkoutStageZone2(
          distanceInKm: 5,
          maxHeartRate: 165,
        ),
      ],
    ),
    act: (bloc) => bloc.add(const WorkoutCreatorEventWorkoutStageUpdated(
      stageIndex: 1,
      workoutStage: WorkoutStageZone2(
        distanceInKm: 7,
        maxHeartRate: 160,
      ),
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        stages: const [
          WorkoutStageCardio(
            distanceInKm: 2,
            maxHeartRate: 150,
          ),
          WorkoutStageZone2(
            distanceInKm: 7,
            maxHeartRate: 160,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'workout stages order changed, '
    'should update list of workout stages in state',
    build: () => createBloc(
      stages: const [
        WorkoutStageCardio(
          distanceInKm: 1,
          maxHeartRate: 150,
        ),
        WorkoutStageZone2(
          distanceInKm: 3,
          maxHeartRate: 165,
        ),
        WorkoutStageCardio(
          distanceInKm: 3,
          maxHeartRate: 150,
        ),
        WorkoutStageZone3(
          distanceInKm: 2,
          maxHeartRate: 180,
        ),
      ],
    ),
    act: (bloc) => bloc.add(const WorkoutCreatorEventWorkoutStagesOrderChanged(
      workoutStages: [
        WorkoutStageCardio(
          distanceInKm: 3,
          maxHeartRate: 150,
        ),
        WorkoutStageZone3(
          distanceInKm: 2,
          maxHeartRate: 180,
        ),
        WorkoutStageCardio(
          distanceInKm: 1,
          maxHeartRate: 150,
        ),
        WorkoutStageZone2(
          distanceInKm: 3,
          maxHeartRate: 165,
        ),
      ],
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        stages: const [
          WorkoutStageCardio(
            distanceInKm: 3,
            maxHeartRate: 150,
          ),
          WorkoutStageZone3(
            distanceInKm: 2,
            maxHeartRate: 180,
          ),
          WorkoutStageCardio(
            distanceInKm: 1,
            maxHeartRate: 150,
          ),
          WorkoutStageZone2(
            distanceInKm: 3,
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
      stages: const [
        WorkoutStageZone2(
          distanceInKm: 5,
          maxHeartRate: 165,
        ),
        WorkoutStageCardio(
          distanceInKm: 15,
          maxHeartRate: 150,
        ),
      ],
    ),
    act: (bloc) => bloc.add(const WorkoutCreatorEventDeleteWorkoutStage(
      index: 0,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        stages: const [
          WorkoutStageCardio(
            distanceInKm: 15,
            maxHeartRate: 150,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'submit, '
    'workout name is not set, '
    'should finish event call',
    build: () => createBloc(
      date: DateTime(2023, 2, 2),
      stages: const [
        WorkoutStageCardio(
          distanceInKm: 4,
          maxHeartRate: 150,
        ),
        WorkoutStageZone3(
          distanceInKm: 2,
          maxHeartRate: 180,
        ),
      ],
    ),
    act: (bloc) => bloc.add(const WorkoutCreatorEventSubmit()),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'list of workout stage is empty, '
    'should finish event call',
    build: () => createBloc(
      date: DateTime(2023, 2, 2),
      workoutName: 'workout 1',
    ),
    act: (bloc) => bloc.add(const WorkoutCreatorEventSubmit()),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => createBloc(
      date: DateTime(2023, 2, 2),
      workoutName: 'workout 1',
      stages: const [
        WorkoutStageCardio(
          distanceInKm: 4,
          maxHeartRate: 150,
        ),
        WorkoutStageZone3(
          distanceInKm: 2,
          maxHeartRate: 180,
        ),
      ],
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const WorkoutCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
        workoutName: 'workout 1',
        stages: const [
          WorkoutStageCardio(
            distanceInKm: 4,
            maxHeartRate: 150,
          ),
          WorkoutStageZone3(
            distanceInKm: 2,
            maxHeartRate: 180,
          ),
        ],
      ),
    ],
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
      stages: const [
        WorkoutStageCardio(
          distanceInKm: 4,
          maxHeartRate: 150,
        ),
        WorkoutStageZone3(
          distanceInKm: 2,
          maxHeartRate: 180,
        ),
      ],
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockAddWorkout();
    },
    act: (bloc) => bloc.add(const WorkoutCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        workoutName: 'workout 1',
        stages: const [
          WorkoutStageCardio(
            distanceInKm: 4,
            maxHeartRate: 150,
          ),
          WorkoutStageZone3(
            distanceInKm: 2,
            maxHeartRate: 180,
          ),
        ],
      ),
      createState(
        status: const BlocStatusComplete<WorkoutCreatorBlocInfo>(
          info: WorkoutCreatorBlocInfo.workoutAdded,
        ),
        workoutName: 'workout 1',
        stages: const [
          WorkoutStageCardio(
            distanceInKm: 4,
            maxHeartRate: 150,
          ),
          WorkoutStageZone3(
            distanceInKm: 2,
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
          userId: loggedUserId,
          workoutName: 'workout 1',
          date: DateTime(2023, 2, 2),
          status: const RunStatusPending(),
          stages: const [
            WorkoutStageCardio(
              distanceInKm: 4,
              maxHeartRate: 150,
            ),
            WorkoutStageZone3(
              distanceInKm: 2,
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
        id: workoutId,
        name: 'workout name',
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
          distanceInKm: 4,
          maxHeartRate: 150,
        ),
        WorkoutStageZone3(
          distanceInKm: 2,
          maxHeartRate: 180,
        ),
      ],
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockUpdateWorkout();
    },
    act: (bloc) => bloc.add(const WorkoutCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        workout: createWorkout(
          id: workoutId,
          name: 'workout name',
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
            distanceInKm: 4,
            maxHeartRate: 150,
          ),
          WorkoutStageZone3(
            distanceInKm: 2,
            maxHeartRate: 180,
          ),
        ],
      ),
      createState(
        status: const BlocStatusComplete<WorkoutCreatorBlocInfo>(
          info: WorkoutCreatorBlocInfo.workoutUpdated,
        ),
        workout: createWorkout(
          id: workoutId,
          name: 'workout name',
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
            distanceInKm: 4,
            maxHeartRate: 150,
          ),
          WorkoutStageZone3(
            distanceInKm: 2,
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
          workoutId: workoutId,
          userId: loggedUserId,
          workoutName: 'workout 1',
          stages: const [
            WorkoutStageCardio(
              distanceInKm: 4,
              maxHeartRate: 150,
            ),
            WorkoutStageZone3(
              distanceInKm: 2,
              maxHeartRate: 180,
            ),
          ],
        ),
      ).called(1);
    },
  );
}
