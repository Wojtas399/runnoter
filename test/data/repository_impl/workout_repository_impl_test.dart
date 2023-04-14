import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/workout_repository_impl.dart';
import 'package:runnoter/domain/model/workout.dart';

import '../../mock/firebase/mock_firebase_workout_service.dart';
import '../../mock/presentation/service/mock_date_service.dart';
import '../../util/workout_creator.dart';
import '../../util/workout_dto_creator.dart';

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
    'get workouts from week, '
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
      final List<WorkoutDto> newlyLoadedWorkoutDtos = [
        createWorkoutDto(
          id: 'w5',
          userId: userId,
          date: DateTime(2023, 4, 6),
          name: 'workout name 1.2',
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
      firebaseWorkoutService.mockLoadWorkoutsByUserIdAndDateRange(
        workoutDtos: newlyLoadedWorkoutDtos,
      );
      repository = createRepository(
        initialState: existingWorkouts,
      );

      final Stream<List<Workout>?> workouts$ =
          repository.getWorkoutsByUserIdAndDateRange(
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
              createWorkout(
                id: 'w5',
                userId: userId,
                date: DateTime(2023, 4, 6),
                name: 'workout name 1.2',
              ),
            ],
          ],
        ),
      );
      verify(
        () => firebaseWorkoutService.loadWorkoutsByUserIdAndDateRange(
          userId: userId,
          startDate: startDate,
          endDate: endDate,
        ),
      ).called(1);
    },
  );
}
