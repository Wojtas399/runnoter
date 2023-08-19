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

import '../../../creators/workout_creator.dart';
import '../../../mock/domain/repository/mock_workout_repository.dart';

void main() {
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
    DateTime? date,
    String? workoutName,
    List<WorkoutStage>? stages,
    ActivityStatus? activityStatus,
  }) =>
      WorkoutPreviewState(
        status: status,
        date: date,
        workoutName: workoutName,
        stages: stages,
        activityStatus: activityStatus,
      );

  setUpAll(() {
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
  });

  tearDown(() {
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
      final StreamController<Workout?> workout$ = StreamController();

      blocTest(
        'initialize, '
        'should set listener of workout matching to given id',
        build: () => createBloc(workoutId: workoutId),
        setUp: () => workoutRepository.mockGetWorkoutById(
          workoutStream: workout$.stream,
        ),
        act: (bloc) async {
          bloc.add(const WorkoutPreviewEventInitialize());
          await bloc.stream.first;
          workout$.add(updatedWorkout);
        },
        expect: () => [
          createState(
            status: const BlocStatusComplete(),
            date: workout.date,
            stages: workout.stages,
            activityStatus: workout.status,
            workoutName: workout.name,
          ),
          createState(
            status: const BlocStatusComplete(),
            date: updatedWorkout.date,
            stages: updatedWorkout.stages,
            activityStatus: updatedWorkout.status,
            workoutName: updatedWorkout.name,
          ),
        ],
        verify: (_) => verify(
          () => workoutRepository.getWorkoutById(
            userId: userId,
            workoutId: workoutId,
          ),
        ).called(1),
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
