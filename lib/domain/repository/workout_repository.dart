import '../model/workout.dart';
import '../model/workout_stage.dart';
import '../model/workout_status.dart';

abstract class WorkoutRepository {
  Stream<List<Workout>?> getWorkoutsByUserIdAndDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Stream<Workout?> getWorkoutByUserIdAndDate({
    required String userId,
    required DateTime date,
  });

  Future<void> addWorkout({
    required String userId,
    required String workoutName,
    required DateTime date,
    required WorkoutStatus status,
    required List<WorkoutStage> stages,
  });

  Future<void> deleteWorkout({
    required String userId,
    required String workoutId,
  });
}
