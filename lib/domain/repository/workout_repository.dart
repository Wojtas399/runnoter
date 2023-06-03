import '../entity/workout.dart';
import '../entity/workout_stage.dart';
import '../entity/workout_status.dart';

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

  Stream<Workout?> getWorkoutByDate({
    required DateTime date,
    required String userId,
  });

  Stream<List<Workout>?> getAllWorkouts({
    required String userId,
  });

  Future<void> addWorkout({
    required String userId,
    required String workoutName,
    required DateTime date,
    required WorkoutStatus status,
    required List<WorkoutStage> stages,
  });

  Future<void> updateWorkout({
    required String workoutId,
    required String userId,
    String? workoutName,
    WorkoutStatus? status,
    List<WorkoutStage>? stages,
  });

  Future<void> deleteWorkout({
    required String userId,
    required String workoutId,
  });
}
