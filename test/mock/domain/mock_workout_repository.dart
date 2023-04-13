import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/workout.dart';
import 'package:runnoter/domain/repository/workout_repository.dart';

class MockWorkoutRepository extends Mock implements WorkoutRepository {
  void mockGetWorkoutsByUserIdAndDateRange({
    List<Workout>? workouts,
  }) {
    when(
      () => getWorkoutsByUserIdAndDateRange(
        userId: any(named: 'userId'),
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      ),
    ).thenAnswer((invocation) => Stream.value(workouts));
  }
}
