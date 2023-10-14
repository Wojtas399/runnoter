import 'package:runnoter/data/entity/workout.dart';
import 'package:runnoter/domain/additional_model/activity_status.dart';
import 'package:runnoter/domain/additional_model/workout_stage.dart';

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
