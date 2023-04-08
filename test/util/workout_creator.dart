import 'package:runnoter/domain/model/workout.dart';
import 'package:runnoter/domain/model/workout_stage.dart';
import 'package:runnoter/domain/model/workout_status.dart';

Workout createWorkout({
  String id = 'u1',
  DateTime? date,
  WorkoutStatus status = const WorkoutStatusPending(),
  String name = '',
  List<WorkoutStage> stages = const [],
  AdditionalWorkout? additionalWorkout,
}) {
  return Workout(
    id: id,
    date: date ?? DateTime(2023, 1, 1),
    status: status,
    name: name,
    stages: stages,
    additionalWorkout: additionalWorkout,
  );
}
