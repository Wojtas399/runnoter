import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/workout.dart';
import 'package:runnoter/domain/repository/workout_repository.dart';

class MockWorkoutRepository extends Mock implements WorkoutRepository {
  void mockGetWorkoutsFromWeek({
    List<Workout>? workouts,
  }) {
    when(
      () => getWorkoutsFromWeek(
        userId: any(named: 'userId'),
        dateFromWeek: any(named: 'dateFromWeek'),
      ),
    ).thenAnswer((invocation) => Stream.value(workouts));
  }
}
