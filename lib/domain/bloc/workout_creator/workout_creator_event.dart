part of 'workout_creator_bloc.dart';

abstract class WorkoutCreatorEvent {
  const WorkoutCreatorEvent();
}

class WorkoutCreatorEventInitialize extends WorkoutCreatorEvent {
  final DateTime date;
  final String? workoutId;

  const WorkoutCreatorEventInitialize({
    required this.date,
    this.workoutId,
  });
}

class WorkoutCreatorEventWorkoutNameChanged extends WorkoutCreatorEvent {
  final String? workoutName;

  const WorkoutCreatorEventWorkoutNameChanged({
    required this.workoutName,
  });
}

class WorkoutCreatorEventWorkoutStageAdded extends WorkoutCreatorEvent {
  final WorkoutStage workoutStage;

  const WorkoutCreatorEventWorkoutStageAdded({
    required this.workoutStage,
  });
}

class WorkoutCreatorEventWorkoutStageUpdated extends WorkoutCreatorEvent {
  final int stageIndex;
  final WorkoutStage workoutStage;

  const WorkoutCreatorEventWorkoutStageUpdated({
    required this.stageIndex,
    required this.workoutStage,
  });
}

class WorkoutCreatorEventWorkoutStagesOrderChanged extends WorkoutCreatorEvent {
  final List<WorkoutStage> workoutStages;

  const WorkoutCreatorEventWorkoutStagesOrderChanged({
    required this.workoutStages,
  });
}

class WorkoutCreatorEventDeleteWorkoutStage extends WorkoutCreatorEvent {
  final int index;

  const WorkoutCreatorEventDeleteWorkoutStage({
    required this.index,
  });
}

class WorkoutCreatorEventSubmit extends WorkoutCreatorEvent {
  const WorkoutCreatorEventSubmit();
}
