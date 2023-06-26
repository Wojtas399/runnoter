import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/workout_preview/workout_preview_bloc.dart';
import 'package:runnoter/domain/entity/run_status.dart';
import 'package:runnoter/domain/entity/workout_stage.dart';

import '../../../creators/workout_creator.dart';
import '../../../mock/domain/repository/mock_workout_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();
  const String workoutId = 'w1';

  WorkoutPreviewBloc createBloc({
    DateTime? date,
    String? workoutName,
    List<WorkoutStage>? stages,
    RunStatus? runStatus,
  }) {
    return WorkoutPreviewBloc(
      workoutId: workoutId,
      authService: authService,
      workoutRepository: workoutRepository,
      state: WorkoutPreviewState(
        status: const BlocStatusInitial(),
        date: date,
        workoutName: workoutName,
        stages: stages,
        runStatus: runStatus,
      ),
    );
  }

  WorkoutPreviewState createState({
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
    String? workoutName,
    List<WorkoutStage>? stages,
    RunStatus? runStatus,
  }) {
    return WorkoutPreviewState(
      status: status,
      date: date,
      workoutName: workoutName,
      stages: stages,
      runStatus: runStatus,
    );
  }

  tearDown(() {
    reset(authService);
    reset(workoutRepository);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should finish event call',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (WorkoutPreviewBloc bloc) => bloc.add(
      const WorkoutPreviewEventInitialize(),
    ),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'should set listener of workout matching to given id',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockGetWorkoutById(
        workout: createWorkout(
          id: workoutId,
          date: DateTime(2023),
          stages: [],
          status: const RunStatusPending(),
          name: 'workout name',
        ),
      );
    },
    act: (WorkoutPreviewBloc bloc) => bloc.add(
      const WorkoutPreviewEventInitialize(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        date: DateTime(2023),
        stages: [],
        runStatus: const RunStatusPending(),
        workoutName: 'workout name',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getWorkoutById(
          userId: 'u1',
          workoutId: workoutId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'workout updated, '
    'new workout is null, '
    'should set state with all params set as null',
    build: () => createBloc(
      date: DateTime(2023),
      workoutName: 'workout name',
      stages: [],
      runStatus: const RunStatusPending(),
    ),
    act: (WorkoutPreviewBloc bloc) => bloc.add(
      const WorkoutPreviewEventWorkoutUpdated(workout: null),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
      ),
    ],
  );

  blocTest(
    'workout updated, '
    'new workout is not null, '
    'should update workout date, name, stages and status in state',
    build: () => createBloc(),
    act: (WorkoutPreviewBloc bloc) => bloc.add(
      WorkoutPreviewEventWorkoutUpdated(
        workout: createWorkout(
          id: workoutId,
          userId: 'u1',
          date: DateTime(2023),
          name: 'workout name',
          stages: [
            WorkoutStageBaseRun(
              distanceInKilometers: 10,
              maxHeartRate: 150,
            ),
          ],
          status: const RunStatusPending(),
        ),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        date: DateTime(2023),
        workoutName: 'workout name',
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 10,
            maxHeartRate: 150,
          ),
        ],
        runStatus: const RunStatusPending(),
      ),
    ],
  );

  blocTest(
    'delete workout, '
    'logged user does not exist, '
    'should finish event call',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (WorkoutPreviewBloc bloc) => bloc.add(
      const WorkoutPreviewEventDeleteWorkout(),
    ),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'delete workout, '
    'should call method from workout repository to delete workout and should emit info that workout has been deleted',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockDeleteWorkout();
    },
    act: (WorkoutPreviewBloc bloc) => bloc.add(
      const WorkoutPreviewEventDeleteWorkout(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete<WorkoutPreviewBlocInfo>(
          info: WorkoutPreviewBlocInfo.workoutDeleted,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.deleteWorkout(
          userId: 'u1',
          workoutId: workoutId,
        ),
      ).called(1);
    },
  );
}
