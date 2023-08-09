import 'package:runnoter/domain/additional_model/run_status.dart';
import 'package:runnoter/domain/additional_model/workout_stage.dart';
import 'package:runnoter/domain/entity/workout.dart';

Workout createWorkout({
  String id = '',
  String userId = '',
  DateTime? date,
  RunStatus status = const RunStatusPending(),
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
