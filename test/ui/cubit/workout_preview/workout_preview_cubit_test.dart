import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/interface/repository/workout_repository.dart';
import 'package:runnoter/data/model/activity.dart';
import 'package:runnoter/data/model/workout.dart';
import 'package:runnoter/ui/cubit/workout_preview/workout_preview_cubit.dart';

import '../../../creators/workout_creator.dart';
import '../../../mock/data/repository/mock_workout_repository.dart';

void main() {
  final workoutRepository = MockWorkoutRepository();
  const String userId = 'u1';
  const String workoutId = 'w1';

  WorkoutPreviewCubit createCubit() =>
      WorkoutPreviewCubit(userId: userId, workoutId: workoutId);

  setUpAll(() {
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
  });

  tearDown(() {
    reset(workoutRepository);
  });

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
      final StreamController<Workout?> workout$ = StreamController()
        ..add(workout);

      blocTest(
        'should set listener of workout matching to given id',
        build: () => createCubit(),
        setUp: () => workoutRepository.mockGetWorkoutById(
          workoutStream: workout$.stream,
        ),
        act: (bloc) {
          bloc.initialize();
          workout$.add(updatedWorkout);
        },
        expect: () => [
          WorkoutPreviewState(
            date: workout.date,
            stages: workout.stages,
            activityStatus: workout.status,
            workoutName: workout.name,
          ),
          WorkoutPreviewState(
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
    "should call workout repository's method to delete workout",
    build: () => createCubit(),
    setUp: () => workoutRepository.mockDeleteWorkout(),
    act: (bloc) => bloc.deleteWorkout(),
    expect: () => [],
    verify: (_) => verify(
      () => workoutRepository.deleteWorkout(
        userId: userId,
        workoutId: workoutId,
      ),
    ).called(1),
  );
}
