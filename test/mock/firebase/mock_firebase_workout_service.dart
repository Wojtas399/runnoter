import 'package:firebase/firebase.dart';
import 'package:firebase/service/firebase_workout_service.dart';
import 'package:mocktail/mocktail.dart';

class _FakeWorkoutStatusDto extends Fake implements WorkoutStatusDto {}

class MockFirebaseWorkoutService extends Mock
    implements FirebaseWorkoutService {
  void mockLoadWorkoutsByUserIdAndDateRange({
    List<WorkoutDto>? workoutDtos,
  }) {
    when(
      () => loadWorkoutsByUserIdAndDateRange(
        userId: any(named: 'userId'),
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      ),
    ).thenAnswer((invocation) => Future.value(workoutDtos));
  }

  void mockLoadWorkoutByUserIdAndDate({
    WorkoutDto? workoutDto,
  }) {
    when(
      () => loadWorkoutByUserIdAndDate(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer((invocation) => Future.value(workoutDto));
  }

  void mockAddWorkout({
    WorkoutDto? addedWorkoutDto,
  }) {
    _mockWorkoutStatusDto();
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

  void mockDeleteWorkout() {
    when(
      () => deleteWorkout(
        userId: any(named: 'userId'),
        workoutId: any(named: 'workoutId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void _mockWorkoutStatusDto() {
    registerFallbackValue(_FakeWorkoutStatusDto());
  }
}
