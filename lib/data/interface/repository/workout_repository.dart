import '../../entity/activity.dart';
import '../../entity/workout.dart';

abstract class WorkoutRepository {
  Stream<List<Workout>?> getWorkoutsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  });

  Stream<Workout?> getWorkoutById({
    required String workoutId,
    required String userId,
  });

  Stream<List<Workout>?> getWorkoutsByDate({
    required DateTime date,
    required String userId,
  });

  Stream<List<Workout>?> getAllWorkouts({required String userId});

  Future<void> refreshWorkoutsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  });

  Future<void> addWorkout({
    required String userId,
    required String workoutName,
    required DateTime date,
    required ActivityStatus status,
    required List<WorkoutStage> stages,
  });

  Future<void> updateWorkout({
    required String workoutId,
    required String userId,
    DateTime? date,
    String? workoutName,
    ActivityStatus? status,
    List<WorkoutStage>? stages,
  });

  Future<void> deleteWorkout({
    required String userId,
    required String workoutId,
  });

  Future<void> deleteAllUserWorkouts({required String userId});
}
