import '../model/workout.dart';
import '../model/workout_stage.dart';
import '../model/workout_status.dart';

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
