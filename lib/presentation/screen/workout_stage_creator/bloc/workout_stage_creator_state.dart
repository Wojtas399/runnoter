import '../../../model/bloc_state.dart';

abstract class WorkoutStageCreatorState
    extends BlocState<WorkoutStageCreatorState> {
  const WorkoutStageCreatorState({
    required super.status,
  });

  bool get areDataCorrect;
}

enum WorkoutStage {
  baseRun,
  zone2,
  zone3,
  hillRepeats,
  rhythms,
  stretching,
  strengthening,
  foamRolling,
}
