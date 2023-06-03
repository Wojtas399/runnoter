import 'package:runnoter/domain/entity/workout.dart';
import 'package:runnoter/domain/entity/workout_stage.dart';
import 'package:runnoter/domain/entity/workout_status.dart';

Workout createWorkout({
  String id = '',
  String userId = '',
  DateTime? date,
  WorkoutStatus status = const WorkoutStatusPending(),
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
