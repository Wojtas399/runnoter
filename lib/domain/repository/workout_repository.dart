import '../model/workout.dart';

abstract class WorkoutRepository {
  Stream<List<Workout>?> getWorkoutsFromWeek({
    required String userId,
    required DateTime dateFromWeek,
  });
}
