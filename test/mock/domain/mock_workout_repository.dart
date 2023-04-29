import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/workout.dart';
import 'package:runnoter/domain/model/workout_status.dart';
import 'package:runnoter/domain/repository/workout_repository.dart';

class _FakeWorkoutStatus extends Fake implements WorkoutStatus {}

class MockWorkoutRepository extends Mock implements WorkoutRepository {
  void mockGetWorkoutsByDateRange({
    List<Workout>? workouts,
  }) {
    when(
      () => getWorkoutsByDateRange(
        userId: any(named: 'userId'),
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      ),
    ).thenAnswer((invocation) => Stream.value(workouts));
  }

  void mockGetWorkoutById({
    Workout? workout,
  }) {
    when(
      () => getWorkoutById(
        workoutId: any(named: 'workoutId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Stream.value(workout));
  }

  void mockGetWorkoutByDate({
    Workout? workout,
  }) {
    when(
      () => getWorkoutByDate(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer((invocation) => Stream.value(workout));
  }

  void mockAddWorkout() {
    _mockWorkoutStatus();
    when(
      () => addWorkout(
        userId: any(named: 'userId'),
        workoutName: any(named: 'workoutName'),
        date: any(named: 'date'),
        status: any(named: 'status'),
        stages: any(named: 'stages'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockUpdateWorkout() {
    _mockWorkoutStatus();
    when(
      () => updateWorkout(
        workoutId: any(named: 'workoutId'),
        userId: any(named: 'userId'),
        workoutName: any(named: 'workoutName'),
        status: any(named: 'status'),
        stages: any(named: 'stages'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockDeleteWorkout() {
    when(
      () => deleteWorkout(
        userId: any(named: 'userId'),
        workoutId: any(named: 'workoutId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void _mockWorkoutStatus() {
    registerFallbackValue(_FakeWorkoutStatus());
  }
}
