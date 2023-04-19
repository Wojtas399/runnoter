import 'workout_stage_creator_state.dart';

abstract class WorkoutStageCreatorEvent {
  const WorkoutStageCreatorEvent();
}

class WorkoutStageCreatorEventStageTypeChanged
    extends WorkoutStageCreatorEvent {
  final WorkoutStage stage;

  const WorkoutStageCreatorEventStageTypeChanged({
    required this.stage,
  });
}
