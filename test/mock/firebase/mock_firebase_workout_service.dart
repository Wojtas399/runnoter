import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class _FakeActivityStatusDto extends Fake implements ActivityStatusDto {}

class MockFirebaseWorkoutService extends Mock
    implements FirebaseWorkoutService {
  MockFirebaseWorkoutService() {
    registerFallbackValue(_FakeActivityStatusDto());
  }

  void mockLoadWorkoutsByDateRange({
    List<WorkoutDto>? workoutDtos,
  }) {
    when(
      () => loadWorkoutsByDateRange(
        userId: any(named: 'userId'),
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      ),
    ).thenAnswer((invocation) => Future.value(workoutDtos));
  }

  void mockLoadWorkoutById({
    WorkoutDto? workoutDto,
  }) {
    when(
      () => loadWorkoutById(
        workoutId: any(named: 'workoutId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(workoutDto));
  }

  void mockLoadWorkoutsByDate({
    List<WorkoutDto>? workoutDtos,
  }) {
    when(
      () => loadWorkoutsByDate(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer((invocation) => Future.value(workoutDtos));
  }

  void mockLoadAllWorkouts({
    List<WorkoutDto>? workoutDtos,
  }) {
    when(
      () => loadAllWorkouts(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(workoutDtos));
  }

  void mockAddWorkout({
    WorkoutDto? addedWorkoutDto,
  }) {
    when(
      () => addWorkout(
        userId: any(named: 'userId'),
        workoutName: any(named: 'workoutName'),
        date: any(named: 'date'),
        status: any(named: 'status'),
        stages: any(named: 'stages'),
      ),
    ).thenAnswer((invocation) => Future.value(addedWorkoutDto));
  }

  void mockUpdateWorkout({
    WorkoutDto? updatedWorkoutDto,
  }) {
    when(
      () => updateWorkout(
        workoutId: any(named: 'workoutId'),
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        workoutName: any(named: 'workoutName'),
        status: any(named: 'status'),
        stages: any(named: 'stages'),
      ),
    ).thenAnswer((invocation) => Future.value(updatedWorkoutDto));
  }

  void mockDeleteWorkout() {
    when(
      () => deleteWorkout(
        userId: any(named: 'userId'),
        workoutId: any(named: 'workoutId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockDeleteAllUserWorkouts({
    required List<String> idsOfDeletedWorkouts,
  }) {
    when(
      () => deleteAllUserWorkouts(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(idsOfDeletedWorkouts));
  }
}
