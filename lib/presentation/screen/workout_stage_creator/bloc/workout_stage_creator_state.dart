import '../../../model/bloc_state.dart';

abstract class WorkoutStageCreatorState
    extends BlocState<WorkoutStageCreatorState> {
  const WorkoutStageCreatorState({
    required super.status,
  });

  bool get areDataCorrect;
}

enum WorkoutStage {
  cardio,
  zone2,
  zone3,
  stretching,
  strengthening,
  foamRolling,
}
