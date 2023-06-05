import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/model/pace_dto.dart';
import 'package:firebase/model/workout_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/workout_repository_impl.dart';
import 'package:runnoter/domain/entity/run_status.dart';
import 'package:runnoter/domain/entity/workout.dart';
import 'package:runnoter/domain/entity/workout_stage.dart';

import '../../creators/workout_creator.dart';
import '../../creators/workout_dto_creator.dart';
import '../../mock/common/mock_date_service.dart';
import '../../mock/firebase/mock_firebase_workout_service.dart';

void main() {
  final firebaseWorkoutService = MockFirebaseWorkoutService();
  final dateService = MockDateService();
  late WorkoutRepositoryImpl repository;
  const String userId = 'u1';

  WorkoutRepositoryImpl createRepository({
    List<Workout>? initialState,
  }) {
    return WorkoutRepositoryImpl(
      firebaseWorkoutService: firebaseWorkoutService,
      dateService: dateService,
      initialState: initialState,
    );
  }

  setUp(() {
    repository = createRepository();
  });

  tearDown(() {
    reset(firebaseWorkoutService);
    reset(dateService);
  });

  test(
    'get workouts by date range, '
    'should emit workouts existing in state and should load workouts from firebase and add them to repository',
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
      firebaseWorkoutService.mockLoadWorkoutsByDateRange(
        workoutDtos: newlyLoadedWorkoutDtos,
      );
      repository = createRepository(
        initialState: existingWorkouts,
      );

      final Stream<List<Workout>?> workouts$ =
          repository.getWorkoutsByDateRange(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );
      workouts$.listen((event) {});

      expect(
        workouts$,
        emitsInOrder(
          [
            [
              existingWorkouts[0],
            ],
            [
              existingWorkouts[0],
              ...newlyLoadedWorkouts,
            ],
          ],
        ),
      );
      verify(
        () => firebaseWorkoutService.loadWorkoutsByDateRange(
          userId: userId,
          startDate: startDate,
          endDate: endDate,
        ),
      ).called(1);
    },
  );

  test(
    'get workout by id, '
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
      repository = createRepository(initialState: existingWorkouts);

      final Stream<Workout?> workout$ = repository.getWorkoutById(
        workoutId: id,
        userId: userId,
      );
      workout$.listen((_) {});

      expect(
        workout$,
        emitsInOrder(
          [
            expectedWorkout,
          ],
        ),
      );
    },
  );

  test(
    'get workout by id, '
    'workout does not exist in repository, '
    'should load workout from firebase, add it to repository and emit it',
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
      repository = createRepository(initialState: existingWorkouts);
      firebaseWorkoutService.mockLoadWorkoutById(
        workoutDto: expectedWorkoutDto,
      );

      final Stream<Workout?> workout$ = repository.getWorkoutById(
        workoutId: id,
        userId: userId,
      );
      workout$.listen((_) {});

      expect(
        workout$,
        emitsInOrder(
          [
            null,
            expectedWorkout,
          ],
        ),
      );
      verify(
        () => firebaseWorkoutService.loadWorkoutById(
          workoutId: id,
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'get workout by date, '
    'should emit workout if it exists in repository and should call firebase method to load workout',
    () {
      final DateTime date = DateTime(2023, 2, 1);
      final Workout expectedWorkoutFromRepo = createWorkout(
        id: 'w1',
        userId: userId,
        date: date,
        name: 'workout name',
      );
      final Workout expectedWorkoutFromFirebase = createWorkout(
        id: 'w1',
        userId: userId,
        date: date,
        name: 'firebase workout name',
      );
      final WorkoutDto expectedWorkoutDto = createWorkoutDto(
        id: expectedWorkoutFromFirebase.id,
        userId: userId,
        date: date,
        name: expectedWorkoutFromFirebase.name,
      );
      dateService.mockAreDatesTheSame(expected: true);
      firebaseWorkoutService.mockLoadWorkoutByDate(
        workoutDto: expectedWorkoutDto,
      );
      repository = createRepository(
        initialState: [expectedWorkoutFromRepo],
      );

      final Stream<Workout?> workout$ = repository.getWorkoutByDate(
        userId: userId,
        date: date,
      );
      workout$.listen((_) {});

      expect(
        workout$,
        emitsInOrder(
          [
            expectedWorkoutFromRepo,
            expectedWorkoutFromFirebase,
          ],
        ),
      );
      verify(
        () => firebaseWorkoutService.loadWorkoutByDate(
          userId: userId,
          date: date,
        ),
      ).called(1);
    },
  );

  test(
    'get all workouts, '
    'should emit workouts existing in state and should load workouts from firebase and add them to repository',
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
      firebaseWorkoutService.mockLoadAllWorkouts(
        workoutDtos: newlyLoadedWorkoutDtos,
      );
      repository = createRepository(
        initialState: existingWorkouts,
      );

      final Stream<List<Workout>?> workouts$ =
          repository.getAllWorkouts(userId: userId);
      workouts$.listen((event) {});

      expect(
        workouts$,
        emitsInOrder(
          [
            [
              existingWorkouts[1],
            ],
            [
              existingWorkouts[1],
              ...newlyLoadedWorkouts,
            ],
          ],
        ),
      );
      verify(
        () => firebaseWorkoutService.loadAllWorkouts(
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'add workout, '
    'should call method from firebase service to add workout and should add new workout to repository',
    () async {
      const String id = 'w3';
      const String workoutName = 'workout 3';
      final DateTime date = DateTime(2023, 2, 2);
      const RunStatus status = RunStatusPending();
      final List<WorkoutStage> stages = [
        WorkoutStageBaseRun(
          distanceInKilometers: 2,
          maxHeartRate: 150,
        ),
        WorkoutStageZone2(
          distanceInKilometers: 3,
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
        status: const firebase.RunStatusPendingDto(),
        stages: [
          firebase.WorkoutStageBaseRunDto(
            distanceInKilometers: 2,
            maxHeartRate: 150,
          ),
          firebase.WorkoutStageZone2Dto(
            distanceInKilometers: 3,
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
      firebaseWorkoutService.mockAddWorkout(addedWorkoutDto: addedWorkoutDto);
      repository = createRepository(initialState: existingWorkouts);

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
        () => firebaseWorkoutService.addWorkout(
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
    'update workout, '
    'should call method from firebase service to update workout and should update workout in repository',
    () {
      const String id = 'w1';
      const String newWorkoutName = 'new workout name';
      final RunStatus newStatus = RunStatusDone(
        coveredDistanceInKm: 10,
        avgPace: const Pace(minutes: 6, seconds: 2),
        avgHeartRate: 150,
        moodRate: MoodRate.mr8,
        comment: 'Nice workout!',
      );
      final newStatusDto = firebase.RunStatusDoneDto(
        coveredDistanceInKm: 10,
        avgPaceDto: const PaceDto(minutes: 6, seconds: 2),
        avgHeartRate: 150,
        moodRate: firebase.MoodRate.mr8,
        comment: 'Nice workout!',
      );
      final List<WorkoutStage> newStages = [
        WorkoutStageBaseRun(
          distanceInKilometers: 10,
          maxHeartRate: 150,
        ),
      ];
      final List<firebase.WorkoutStageDto> newStageDtos = [
        firebase.WorkoutStageBaseRunDto(
          distanceInKilometers: 10,
          maxHeartRate: 150,
        ),
      ];
      final WorkoutDto updatedWorkoutDto = createWorkoutDto(
        id: id,
        userId: userId,
        name: newWorkoutName,
        status: newStatusDto,
        stages: newStageDtos,
      );
      final Workout existingWorkout = createWorkout(
        id: id,
        userId: userId,
        name: 'workout name',
        status: const RunStatusPending(),
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 8,
            maxHeartRate: 150,
          ),
        ],
      );
      final Workout expectedUpdatedWorkout = createWorkout(
        id: id,
        userId: userId,
        name: newWorkoutName,
        status: newStatus,
        stages: newStages,
      );
      firebaseWorkoutService.mockUpdateWorkout(
        updatedWorkoutDto: updatedWorkoutDto,
      );
      repository = createRepository(
        initialState: [existingWorkout],
      );

      final Stream<Workout?> workout$ = repository.getWorkoutById(
        workoutId: id,
        userId: userId,
      );
      workout$.listen((_) {});
      repository.updateWorkout(
        workoutId: id,
        userId: userId,
        workoutName: newWorkoutName,
        status: newStatus,
        stages: newStages,
      );

      expect(
        workout$,
        emitsInOrder(
          [
            existingWorkout,
            expectedUpdatedWorkout,
          ],
        ),
      );
      verify(
        () => firebaseWorkoutService.updateWorkout(
          workoutId: id,
          userId: userId,
          workoutName: newWorkoutName,
          status: newStatusDto,
          stages: newStageDtos,
        ),
      ).called(1);
    },
  );

  test(
    'update workout, '
    'workout name is null, '
    'should call firebase method to update workout with workout name set as null',
    () async {
      const String id = 'w1';
      firebaseWorkoutService.mockUpdateWorkout();

      await repository.updateWorkout(
        workoutId: id,
        userId: userId,
        workoutName: null,
        status: const RunStatusPending(),
        stages: [],
      );

      verify(
        () => firebaseWorkoutService.updateWorkout(
          workoutId: id,
          userId: userId,
          status: const firebase.RunStatusPendingDto(),
          stages: [],
        ),
      ).called(1);
    },
  );

  test(
    'update workout, '
    'workout status is null, '
    'should call firebase method to update workout with workout status set as null',
    () async {
      const String id = 'w1';
      firebaseWorkoutService.mockUpdateWorkout();

      await repository.updateWorkout(
        workoutId: id,
        userId: userId,
        workoutName: 'workout name',
        stages: [],
      );

      verify(
        () => firebaseWorkoutService.updateWorkout(
          workoutId: id,
          userId: userId,
          workoutName: 'workout name',
          status: null,
          stages: [],
        ),
      ).called(1);
    },
  );

  test(
    'update workout, '
    'list of stages is null, '
    'should call firebase method to update workout with stages set as null',
    () async {
      const String id = 'w1';
      firebaseWorkoutService.mockUpdateWorkout();

      await repository.updateWorkout(
        workoutId: id,
        userId: userId,
        workoutName: 'new workout name',
        status: const RunStatusPending(),
      );

      verify(
        () => firebaseWorkoutService.updateWorkout(
          workoutId: id,
          userId: userId,
          workoutName: 'new workout name',
          status: const firebase.RunStatusPendingDto(),
          stages: null,
        ),
      ).called(1);
    },
  );

  test(
    'delete workout, '
    'should call method from firebase service to delete workout and should delete workout from the state of repository',
    () {
      const String id = 'w1';
      final List<Workout> existingWorkouts = [
        createWorkout(id: 'w2', userId: userId),
        createWorkout(id: id, userId: userId),
      ];
      repository = createRepository(initialState: existingWorkouts);
      firebaseWorkoutService.mockDeleteWorkout();

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
        () => firebaseWorkoutService.deleteWorkout(
          userId: userId,
          workoutId: id,
        ),
      ).called(1);
    },
  );
}
