import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/model/pace_dto.dart';
import 'package:firebase/model/workout_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/data/additional_model/activity_status.dart';
import 'package:runnoter/data/additional_model/custom_exception.dart';
import 'package:runnoter/data/additional_model/workout_stage.dart';
import 'package:runnoter/data/entity/workout.dart';
import 'package:runnoter/data/repository_impl/workout_repository_impl.dart';

import '../../creators/workout_creator.dart';
import '../../creators/workout_dto_creator.dart';
import '../../mock/common/mock_date_service.dart';
import '../../mock/firebase/mock_firebase_workout_service.dart';

void main() {
  final dbWorkoutService = MockFirebaseWorkoutService();
  final dateService = MockDateService();
  late WorkoutRepositoryImpl repository;
  const String userId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<DateService>(() => dateService);
    GetIt.I.registerFactory<firebase.FirebaseWorkoutService>(
      () => dbWorkoutService,
    );
  });

  setUp(() {
    repository = WorkoutRepositoryImpl();
  });

  tearDown(() {
    reset(dbWorkoutService);
    reset(dateService);
  });

  test(
    'getWorkoutsByDateRange, '
    'should emit workouts existing in repo and workouts loaded from db',
    () {
      final DateTime startDate = DateTime(2023, 4, 3);
      final DateTime endDate = DateTime(2023, 4, 9);
      final List<Workout> existingWorkouts = [
        createWorkout(
          id: 'w1',
          userId: userId,
          date: DateTime(2023, 4, 6),
          name: 'workout name 1',
        ),
        createWorkout(
          id: 'w2',
          userId: userId,
          date: DateTime(2023, 4, 10),
          name: 'workout name 2',
        ),
        createWorkout(
          id: 'w4',
          userId: 'u2',
          date: DateTime(2023, 4, 5),
          name: 'workout name 1',
        ),
      ];
      final List<firebase.WorkoutDto> newlyLoadedWorkoutDtos = [
        createWorkoutDto(
          id: 'w6',
          userId: userId,
          date: DateTime(2023, 4, 6),
          name: 'workout name 1.2',
        ),
        createWorkoutDto(
          id: 'w5',
          userId: userId,
          date: DateTime(2023, 4, 6),
          name: 'workout name 5',
        ),
      ];
      final List<Workout> newlyLoadedWorkouts = [
        createWorkout(
          id: 'w6',
          userId: userId,
          date: DateTime(2023, 4, 6),
          name: 'workout name 1.2',
        ),
        createWorkout(
          id: 'w5',
          userId: userId,
          date: DateTime(2023, 4, 6),
          name: 'workout name 5',
        ),
      ];
      when(
        () => dateService.isDateFromRange(
          date: DateTime(2023, 4, 6),
          startDate: startDate,
          endDate: endDate,
        ),
      ).thenReturn(true);
      when(
        () => dateService.isDateFromRange(
          date: DateTime(2023, 4, 10),
          startDate: startDate,
          endDate: endDate,
        ),
      ).thenReturn(false);
      when(
        () => dateService.isDateFromRange(
          date: DateTime(2023, 4, 5),
          startDate: startDate,
          endDate: endDate,
        ),
      ).thenReturn(true);
      dbWorkoutService.mockLoadWorkoutsByDateRange(
        workoutDtos: newlyLoadedWorkoutDtos,
      );
      repository = WorkoutRepositoryImpl(
        initialData: existingWorkouts,
      );

      final Stream<List<Workout>?> workouts$ =
          repository.getWorkoutsByDateRange(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );

      expect(
        workouts$,
        emitsInOrder(
          [
            [
              existingWorkouts[0],
              ...newlyLoadedWorkouts,
            ],
          ],
        ),
      );
    },
  );

  test(
    'getWorkoutById, '
    'workout exists in repository, '
    'should emit workout from repository',
    () {
      const String id = 'w1';
      final Workout expectedWorkout = createWorkout(
        id: id,
        userId: userId,
        name: 'workout 1',
      );
      final List<Workout> existingWorkouts = [
        expectedWorkout,
        createWorkout(
          id: 'w2',
          userId: userId,
          name: 'workout 2',
        ),
      ];
      repository = WorkoutRepositoryImpl(initialData: existingWorkouts);

      final Stream<Workout?> workout$ = repository.getWorkoutById(
        workoutId: id,
        userId: userId,
      );

      expect(
        workout$,
        emitsInOrder([expectedWorkout]),
      );
    },
  );

  test(
    'getWorkoutById, '
    'workout does not exist in repository, '
    'should load workout from db, add it to repository and emit it',
    () {
      const String id = 'w1';
      final Workout expectedWorkout = createWorkout(
        id: id,
        userId: userId,
        name: 'workout 1',
      );
      final firebase.WorkoutDto expectedWorkoutDto =
          createWorkoutDto(id: id, userId: userId, name: 'workout 1');
      final List<Workout> existingWorkouts = [
        createWorkout(
          id: 'w2',
          userId: userId,
          name: 'workout 2',
        ),
      ];
      repository = WorkoutRepositoryImpl(initialData: existingWorkouts);
      dbWorkoutService.mockLoadWorkoutById(
        workoutDto: expectedWorkoutDto,
      );

      final Stream<Workout?> workout$ = repository.getWorkoutById(
        workoutId: id,
        userId: userId,
      );

      expect(
        workout$,
        emitsInOrder([expectedWorkout]),
      );
    },
  );

  test(
    'getWorkoutsByDate, '
    'should load workouts from db and should emit workouts belonging to '
    'given user and matching to given date',
    () {
      final DateTime date = DateTime(2023, 2, 1);
      final List<Workout> existingWorkouts = [
        createWorkout(
          id: 'w1',
          userId: userId,
          date: date,
        ),
        createWorkout(
          id: 'w2',
          userId: 'u2',
          date: date,
        ),
        createWorkout(
          id: 'w3',
          userId: userId,
          date: DateTime(2023, 1, 10),
        ),
      ];
      final WorkoutDto loadedWorkoutDto = createWorkoutDto(
        id: 'w4',
        userId: userId,
        date: date,
      );
      final Workout loadedWorkout = createWorkout(
        id: 'w4',
        userId: userId,
        date: date,
      );
      dateService.mockAreDaysTheSame(expected: true);
      when(
        () => dateService.areDaysTheSame(DateTime(2023, 1, 10), date),
      ).thenReturn(false);
      dbWorkoutService.mockLoadWorkoutsByDate(
        workoutDtos: [loadedWorkoutDto],
      );
      repository = WorkoutRepositoryImpl(initialData: existingWorkouts);

      final Stream<List<Workout>?> workouts$ = repository.getWorkoutsByDate(
        userId: userId,
        date: date,
      );

      expect(
        workouts$,
        emitsInOrder(
          [
            [
              existingWorkouts.first,
              loadedWorkout,
            ]
          ],
        ),
      );
    },
  );

  test(
    'getAllWorkouts, '
    'should load workouts from db and should emit '
    'workouts belonging to given user',
    () {
      final List<Workout> existingWorkouts = [
        createWorkout(
          id: 'w1',
          userId: 'u2',
          date: DateTime(2023, 4, 6),
          name: 'workout name 1',
        ),
        createWorkout(
          id: 'w2',
          userId: userId,
          date: DateTime(2023, 4, 10),
          name: 'workout name 2',
        ),
        createWorkout(
          id: 'w4',
          userId: 'u2',
          date: DateTime(2023, 4, 5),
          name: 'workout name 1',
        ),
      ];
      final List<firebase.WorkoutDto> newlyLoadedWorkoutDtos = [
        createWorkoutDto(
          id: 'w6',
          userId: userId,
          date: DateTime(2023, 4, 6),
          name: 'workout name 1.2',
        ),
        createWorkoutDto(
          id: 'w5',
          userId: userId,
          date: DateTime(2023, 4, 6),
          name: 'workout name 5',
        ),
      ];
      final List<Workout> newlyLoadedWorkouts = [
        createWorkout(
          id: 'w6',
          userId: userId,
          date: DateTime(2023, 4, 6),
          name: 'workout name 1.2',
        ),
        createWorkout(
          id: 'w5',
          userId: userId,
          date: DateTime(2023, 4, 6),
          name: 'workout name 5',
        ),
      ];
      final List<Workout> expectedWorkouts = [
        existingWorkouts[1],
        ...newlyLoadedWorkouts,
      ];
      dbWorkoutService.mockLoadAllWorkouts(
        workoutDtos: newlyLoadedWorkoutDtos,
      );
      repository = WorkoutRepositoryImpl(
        initialData: existingWorkouts,
      );

      final Stream<List<Workout>?> workouts$ =
          repository.getAllWorkouts(userId: userId);

      expect(
        workouts$,
        emitsInOrder(
          [expectedWorkouts],
        ),
      );
    },
  );

  test(
    'refreshWorkoutsByDateRange, '
    'should load workouts by date range from db and '
    'should add or update them in repo',
    () async {
      final DateTime startDate = DateTime(2023, 1, 10);
      final DateTime endDate = DateTime(2023, 1, 16);
      final List<Workout> existingWorkouts = [
        createWorkout(
          id: 'w1',
          userId: userId,
          name: 'first workout',
          date: DateTime(2023, 1, 11),
        ),
        createWorkout(id: 'w2', userId: userId, date: DateTime(2023, 1, 9)),
        createWorkout(id: 'w3', userId: userId, date: DateTime(2023, 1, 18)),
        createWorkout(id: 'w4', userId: userId, date: DateTime(2023, 1, 15)),
        createWorkout(id: 'w5', userId: 'u2', date: DateTime(2023, 1, 14)),
      ];
      final List<firebase.WorkoutDto> loadedWorkoutDtos = [
        createWorkoutDto(
          id: 'w1',
          userId: userId,
          name: 'updated first workout',
          date: DateTime(2023, 1, 11),
        ),
        createWorkoutDto(id: 'w6', userId: userId, date: DateTime(2023, 1, 13)),
      ];
      final List<Workout> loadedWorkouts = [
        createWorkout(
          id: 'w1',
          userId: userId,
          name: 'updated first workout',
          date: DateTime(2023, 1, 11),
        ),
        createWorkout(id: 'w6', userId: userId, date: DateTime(2023, 1, 13)),
      ];
      dateService.mockIsDateFromRange(expected: true);
      when(
        () => dateService.isDateFromRange(
          date: DateTime(2023, 1, 9),
          startDate: startDate,
          endDate: endDate,
        ),
      ).thenReturn(false);
      when(
        () => dateService.isDateFromRange(
          date: DateTime(2023, 1, 18),
          startDate: startDate,
          endDate: endDate,
        ),
      ).thenReturn(false);
      dbWorkoutService.mockLoadWorkoutsByDateRange(
        workoutDtos: loadedWorkoutDtos,
      );
      repository = WorkoutRepositoryImpl(initialData: existingWorkouts);

      await repository.refreshWorkoutsByDateRange(
        startDate: startDate,
        endDate: endDate,
        userId: userId,
      );

      expect(
        repository.dataStream$,
        emits([
          existingWorkouts[1],
          existingWorkouts[2],
          existingWorkouts.last,
          ...loadedWorkouts,
        ]),
      );
      verify(
        () => dbWorkoutService.loadWorkoutsByDateRange(
          startDate: startDate,
          endDate: endDate,
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'addWorkout, '
    'should add workout to db and repo',
    () async {
      const String id = 'w3';
      const String workoutName = 'workout 3';
      final DateTime date = DateTime(2023, 2, 2);
      const ActivityStatus status = ActivityStatusPending();
      const List<WorkoutStage> stages = [
        WorkoutStageCardio(
          distanceInKm: 2,
          maxHeartRate: 150,
        ),
        WorkoutStageZone2(
          distanceInKm: 3,
          maxHeartRate: 165,
        ),
      ];
      final List<Workout> existingWorkouts = [
        createWorkout(id: 'w1', name: 'workout 1'),
        createWorkout(id: 'w2', name: 'workout 2'),
      ];
      final WorkoutDto addedWorkoutDto = createWorkoutDto(
        id: id,
        userId: userId,
        name: workoutName,
        date: date,
        status: const firebase.ActivityStatusPendingDto(),
        stages: const [
          firebase.WorkoutStageCardioDto(
            distanceInKm: 2,
            maxHeartRate: 150,
          ),
          firebase.WorkoutStageZone2Dto(
            distanceInKm: 3,
            maxHeartRate: 165,
          ),
        ],
      );
      final Workout expectedAddedWorkout = createWorkout(
        id: id,
        name: workoutName,
        userId: userId,
        date: date,
        status: status,
        stages: stages,
      );
      dbWorkoutService.mockAddWorkout(addedWorkoutDto: addedWorkoutDto);
      repository = WorkoutRepositoryImpl(initialData: existingWorkouts);

      await repository.addWorkout(
        userId: userId,
        workoutName: workoutName,
        date: date,
        status: status,
        stages: stages,
      );

      expect(
        await repository.dataStream$.first,
        [...existingWorkouts, expectedAddedWorkout],
      );
      verify(
        () => dbWorkoutService.addWorkout(
          userId: userId,
          workoutName: workoutName,
          date: date,
          status: addedWorkoutDto.status,
          stages: addedWorkoutDto.stages,
        ),
      ).called(1);
    },
  );

  test(
    'updateWorkout, '
    'should update workout in db and repo',
    () async {
      const String id = 'w1';
      final DateTime newDate = DateTime(2023, 5, 10);
      const String newWorkoutName = 'new workout name';
      const ActivityStatus newStatus = ActivityStatusDone(
        coveredDistanceInKm: 10,
        avgPace: Pace(minutes: 6, seconds: 2),
        avgHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'Nice workout!',
      );
      final newStatusDto = firebase.ActivityStatusDoneDto(
        coveredDistanceInKm: 10,
        avgPaceDto: const PaceDto(minutes: 6, seconds: 2),
        avgHeartRate: 150,
        moodRate: firebase.MoodRate.mr8,
        comment: 'Nice workout!',
      );
      const List<WorkoutStage> newStages = [
        WorkoutStageCardio(distanceInKm: 10, maxHeartRate: 150),
      ];
      const List<firebase.WorkoutStageDto> newStageDtos = [
        firebase.WorkoutStageCardioDto(distanceInKm: 10, maxHeartRate: 150),
      ];
      final WorkoutDto updatedWorkoutDto = createWorkoutDto(
        id: id,
        userId: userId,
        date: newDate,
        name: newWorkoutName,
        status: newStatusDto,
        stages: newStageDtos,
      );
      final Workout existingWorkout = createWorkout(
        id: id,
        userId: userId,
        date: DateTime(2023, 5, 5),
        name: 'workout name',
        status: const ActivityStatusPending(),
        stages: const [
          WorkoutStageCardio(distanceInKm: 8, maxHeartRate: 150),
        ],
      );
      final Workout expectedUpdatedWorkout = createWorkout(
        id: id,
        userId: userId,
        date: newDate,
        name: newWorkoutName,
        status: newStatus,
        stages: newStages,
      );
      dbWorkoutService.mockUpdateWorkout(
        updatedWorkoutDto: updatedWorkoutDto,
      );
      repository = WorkoutRepositoryImpl(initialData: [existingWorkout]);

      await repository.updateWorkout(
        workoutId: id,
        userId: userId,
        date: newDate,
        workoutName: newWorkoutName,
        status: newStatus,
        stages: newStages,
      );

      expect(
        repository.getWorkoutById(workoutId: id, userId: userId),
        emits(expectedUpdatedWorkout),
      );
      verify(
        () => dbWorkoutService.updateWorkout(
          workoutId: id,
          userId: userId,
          date: newDate,
          workoutName: newWorkoutName,
          status: newStatusDto,
          stages: newStageDtos,
        ),
      ).called(1);
    },
  );

  test(
    'updateWorkout, '
    'db method throws document exception with documentNotFound code, '
    'should remove entity from repo and '
    'should throw entity exception with entityNotFound code',
    () async {
      const String id = 'w1';
      final DateTime newDate = DateTime(2023, 5, 10);
      const String newWorkoutName = 'new workout name';
      const ActivityStatus newStatus = ActivityStatusUndone();
      const newStatusDto = firebase.ActivityStatusUndoneDto();
      const List<WorkoutStage> newStages = [
        WorkoutStageCardio(distanceInKm: 10, maxHeartRate: 150),
      ];
      const List<firebase.WorkoutStageDto> newStageDtos = [
        firebase.WorkoutStageCardioDto(distanceInKm: 10, maxHeartRate: 150),
      ];
      final Workout existingWorkout = createWorkout(
        id: id,
        userId: userId,
        date: DateTime(2023, 5, 5),
        name: 'workout name',
        status: const ActivityStatusPending(),
        stages: const [
          WorkoutStageCardio(distanceInKm: 8, maxHeartRate: 150),
        ],
      );
      dbWorkoutService.mockUpdateWorkout(
        throwable: const firebase.FirebaseDocumentException(
          code: firebase.FirebaseDocumentExceptionCode.documentNotFound,
        ),
      );
      repository = WorkoutRepositoryImpl(initialData: [existingWorkout]);

      Object? exception;
      try {
        await repository.updateWorkout(
          workoutId: id,
          userId: userId,
          date: newDate,
          workoutName: newWorkoutName,
          status: newStatus,
          stages: newStages,
        );
      } catch (e) {
        exception = e;
      }

      expect(
        exception,
        const EntityException(code: EntityExceptionCode.entityNotFound),
      );
      expect(repository.dataStream$, emits([]));
      verify(
        () => dbWorkoutService.updateWorkout(
          workoutId: id,
          userId: userId,
          date: newDate,
          workoutName: newWorkoutName,
          status: newStatusDto,
          stages: newStageDtos,
        ),
      ).called(1);
    },
  );

  test(
    'deleteWorkout, '
    'should call method from db service to delete workout and should delete workout from the state of repository',
    () {
      const String id = 'w1';
      final List<Workout> existingWorkouts = [
        createWorkout(id: 'w2', userId: userId),
        createWorkout(id: id, userId: userId),
      ];
      repository = WorkoutRepositoryImpl(initialData: existingWorkouts);
      dbWorkoutService.mockDeleteWorkout();

      final Stream<List<Workout>?> repositoryState$ = repository.dataStream$;
      repositoryState$.listen((_) {});
      repository.deleteWorkout(
        userId: userId,
        workoutId: id,
      );

      expect(
        repositoryState$,
        emitsInOrder(
          [
            existingWorkouts,
            [
              existingWorkouts.first,
            ],
          ],
        ),
      );
      verify(
        () => dbWorkoutService.deleteWorkout(
          userId: userId,
          workoutId: id,
        ),
      ).called(1);
    },
  );

  test(
    'deleteAllUserWorkouts, '
    'should call method from db service to delete all user workouts and should delete these workouts from the state of repository',
    () {
      final List<Workout> existingWorkouts = [
        createWorkout(id: 'w5', userId: 'u3'),
        createWorkout(id: 'w2', userId: userId),
        createWorkout(id: 'w1', userId: userId),
        createWorkout(id: 'w3', userId: 'u2'),
        createWorkout(id: 'w4', userId: userId),
      ];
      repository = WorkoutRepositoryImpl(initialData: existingWorkouts);
      dbWorkoutService.mockDeleteAllUserWorkouts(
        idsOfDeletedWorkouts: ['w2', 'w1', 'w4'],
      );

      final Stream<List<Workout>?> repositoryState$ = repository.dataStream$;
      repositoryState$.listen((_) {});
      repository.deleteAllUserWorkouts(
        userId: userId,
      );

      expect(
        repositoryState$,
        emitsInOrder(
          [
            existingWorkouts,
            [
              existingWorkouts.first,
              existingWorkouts[3],
            ],
          ],
        ),
      );
      verify(
        () => dbWorkoutService.deleteAllUserWorkouts(
          userId: userId,
        ),
      ).called(1);
    },
  );
}
