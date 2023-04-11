import 'entity.dart';
import 'workout_stage.dart';
import 'workout_status.dart';

class Workout extends Entity {
  final String userId;
  final DateTime date;
  final WorkoutStatus status;
  final String name;
  final List<WorkoutStage> stages;
  final AdditionalWorkout? additionalWorkout;

  const Workout({
    required super.id,
    required this.userId,
    required this.date,
    required this.status,
    required this.name,
    required this.stages,
    this.additionalWorkout,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        status,
        name,
        stages,
        additionalWorkout,
      ];
}

enum AdditionalWorkout {
  stretching,
  strengthening,
}
