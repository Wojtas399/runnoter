import '../model/workout.dart';

abstract class WorkoutRepository {
  Stream<List<Workout>?> getWorkoutsByUserIdAndDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });
}
