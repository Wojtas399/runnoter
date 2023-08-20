import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/activity_status.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/workout_stage.dart';
import 'package:runnoter/domain/bloc/workout_preview/workout_preview_bloc.dart';
import 'package:runnoter/domain/entity/workout.dart';
import 'package:runnoter/domain/repository/workout_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../creators/workout_creator.dart';
import '../../../mock/domain/repository/mock_workout_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();
  const String userId = 'u1';
  const String workoutId = 'w1';

  WorkoutPreviewBloc createBloc({String? workoutId}) => WorkoutPreviewBloc(
        userId: userId,
        workoutId: workoutId,
        state: const WorkoutPreviewState(status: BlocStatusInitial()),
      );

  WorkoutPreviewState createState({
    BlocStatus status = const BlocStatusInitial(),
    bool canEditWorkoutStatus = true,
    DateTime? date,
    String? workoutName,
    List<WorkoutStage>? stages,
    ActivityStatus? activityStatus,
  }) =>
      WorkoutPreviewState(
        status: status,
        canEditWorkoutStatus: canEditWorkoutStatus,
        date: date,
        workoutName: workoutName,
        stages: stages,
        activityStatus: activityStatus,
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

  group(
    'initialize',
    () {
      final Workout workout = createWorkout(
        id: workoutId,
        date: DateTime(2023, 1),
        stages: [],
        status: const ActivityStatusPending(),
        name: 'workout name',
      );
      final Workout updatedWorkout = createWorkout(
        id: workoutId,
        date: DateTime(2023, 2),
        stages: [],
        status: const ActivityStatusUndone(),
        name: 'updated workout name',
      );
      final StreamController<Workout?> workout1$ = StreamController()
        ..add(workout);
      final StreamController<Workout?> workout2$ = StreamController()
        ..add(workout);

      blocTest(
        'should set canEditWorkoutStatus param to true if user id is equal to logged user id and '
        'should set listener of workout matching to given id',
        build: () => createBloc(workoutId: workoutId),
        setUp: () {
          authService.mockGetLoggedUserId(userId: userId);
          workoutRepository.mockGetWorkoutById(workoutStream: workout1$.stream);
        },
        act: (bloc) async {
          bloc.add(const WorkoutPreviewEventInitialize());
          await bloc.stream.first;
          workout1$.add(updatedWorkout);
        },
        expect: () => [
          createState(
            status: const BlocStatusComplete(),
            canEditWorkoutStatus: true,
            date: workout.date,
            stages: workout.stages,
            activityStatus: workout.status,
            workoutName: workout.name,
          ),
          createState(
            status: const BlocStatusComplete(),
            canEditWorkoutStatus: true,
            date: updatedWorkout.date,
            stages: updatedWorkout.stages,
            activityStatus: updatedWorkout.status,
            workoutName: updatedWorkout.name,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => workoutRepository.getWorkoutById(
              userId: userId,
              workoutId: workoutId,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should set canEditWorkoutStatus param to false if user id is not equal to logged user id',
        build: () => createBloc(workoutId: workoutId),
        setUp: () {
          authService.mockGetLoggedUserId(userId: 'u2');
          workoutRepository.mockGetWorkoutById(workoutStream: workout2$.stream);
        },
        act: (bloc) => bloc.add(const WorkoutPreviewEventInitialize()),
        expect: () => [
          createState(
            status: const BlocStatusComplete(),
            canEditWorkoutStatus: false,
            date: workout.date,
            stages: workout.stages,
            activityStatus: workout.status,
            workoutName: workout.name,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => workoutRepository.getWorkoutById(
              userId: userId,
              workoutId: workoutId,
            ),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'delete workout, '
    'should call method from workout repository to delete workout, '
    'should emit info that workout has been deleted',
    build: () => createBloc(workoutId: workoutId),
    setUp: () => workoutRepository.mockDeleteWorkout(),
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
    verify: (_) => verify(
      () => workoutRepository.deleteWorkout(
        userId: userId,
        workoutId: workoutId,
      ),
    ).called(1),
  );
}
