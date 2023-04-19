import 'package:equatable/equatable.dart';

abstract class WorkoutStageCreatorState extends Equatable {
  const WorkoutStageCreatorState();

  bool get areDataCorrect;

  WorkoutStageCreatorState copyWith();
}

enum WorkoutStage {
  cardio,
  zone2,
  zone3,
  stretching,
  strengthening,
  foamRolling,
}
