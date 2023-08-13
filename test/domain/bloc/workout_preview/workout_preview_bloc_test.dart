import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/run_status.dart';
import 'package:runnoter/domain/additional_model/workout_stage.dart';
import 'package:runnoter/domain/bloc/workout_preview/workout_preview_bloc.dart';
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

  WorkoutPreviewBloc createBloc({
    String? workoutId,
    DateTime? date,
    String? workoutName,
    List<WorkoutStage>? stages,
    RunStatus? runStatus,
  }) =>
      WorkoutPreviewBloc(
        workoutId: workoutId,
        state: WorkoutPreviewState(
          status: const BlocStatusInitial(),
          date: date,
          workoutName: workoutName,
          stages: stages,
          runStatus: runStatus,
        ),
      );

  WorkoutPreviewState createState({
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
    String? workoutName,
    List<WorkoutStage>? stages,
    RunStatus? runStatus,
  }) =>
      WorkoutPreviewState(
        status: status,
        date: date,
        workoutName: workoutName,
        stages: stages,
        runStatus: runStatus,
      );

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
  });

  tearDown(() {
    reset(authService);
    reset(workoutRepository);
  });

  blocTest(
    'initialize, '
    'workout id is null, '
    'should do nothing',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const WorkoutPreviewEventInitialize()),
    expect: () => [],
  );

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createBloc(workoutId: workoutId),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const WorkoutPreviewEventInitialize()),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'should set listener of workout matching to given id',
    build: () => createBloc(workoutId: workoutId),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
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
    act: (bloc) => bloc.add(const WorkoutPreviewEventInitialize()),
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
          userId: loggedUserId,
          workoutId: workoutId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'delete workout, '
    'logged user does not exist, '
    'should finish event call',
    build: () => createBloc(workoutId: workoutId),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const WorkoutPreviewEventDeleteWorkout()),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'delete workout, '
    'should call method from workout repository to delete workout and should emit info that workout has been deleted',
    build: () => createBloc(workoutId: workoutId),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockDeleteWorkout();
    },
    act: (bloc) => bloc.add(const WorkoutPreviewEventDeleteWorkout()),
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
          userId: loggedUserId,
          workoutId: workoutId,
        ),
      ).called(1);
    },
  );
}
