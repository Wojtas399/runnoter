import 'package:runnoter/data/model/activity.dart';
import 'package:runnoter/data/model/workout.dart';

Workout createWorkout({
  String id = '',
  String userId = '',
  DateTime? date,
  ActivityStatus status = const ActivityStatusPending(),
  String name = '',
  List<WorkoutStage> stages = const [],
}) {
  return Workout(
    id: id,
    userId: userId,
    date: date ?? DateTime(2023, 1, 1),
    status: status,
    name: name,
    stages: stages,
  );
}
