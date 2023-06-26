import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/run_status.dart';
import 'package:runnoter/domain/entity/workout.dart';
import 'package:runnoter/domain/repository/workout_repository.dart';

class MockWorkoutRepository extends Mock implements WorkoutRepository {
  MockWorkoutRepository() {
    registerFallbackValue(const RunStatusPending());
  }

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

  void mockGetWorkoutsByDate({
    List<Workout>? workouts,
  }) {
    when(
      () => getWorkoutsByDate(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer((invocation) => Stream.value(workouts));
  }

  void mockGetAllWorkouts({
    List<Workout>? allWorkouts,
  }) {
    when(
      () => getAllWorkouts(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Stream.value(allWorkouts));
  }

  void mockAddWorkout() {
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

  void mockDeleteAllUserWorkouts() {
    when(
      () => deleteAllUserWorkouts(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }
}
