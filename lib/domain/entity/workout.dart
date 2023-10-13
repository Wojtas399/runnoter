import '../../data/entity/activity.dart';
import '../additional_model/workout_stage.dart';

class Workout extends Activity {
  final List<WorkoutStage> stages;

  const Workout({
    required super.id,
    required super.userId,
    required super.date,
    required super.status,
    required super.name,
    required this.stages,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        status,
        name,
        stages,
      ];
}
