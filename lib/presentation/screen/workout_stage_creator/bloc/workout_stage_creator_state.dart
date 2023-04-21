part of 'workout_stage_creator_bloc.dart';

abstract class WorkoutStageCreatorState extends Equatable {
  const WorkoutStageCreatorState();
}

class WorkoutStageCreatorStateInProgress extends WorkoutStageCreatorState {
  final WorkoutStageType? stageType;
  final WorkoutStageCreatorForm? form;

  const WorkoutStageCreatorStateInProgress({
    required this.stageType,
    required this.form,
  });

  @override
  List<Object?> get props => [
        stageType,
        form,
      ];

  bool get isAddButtonDisabled =>
      stageType == null || (form != null ? !form!.areDataCorrect : false);

  WorkoutStageCreatorStateInProgress copyWith({
    WorkoutStageType? stageType,
    WorkoutStageCreatorForm? form,
  }) =>
      WorkoutStageCreatorStateInProgress(
        stageType: stageType ?? this.stageType,
        form: form,
      );
}

class WorkoutStageCreatorStateSubmitted extends WorkoutStageCreatorState {
  final WorkoutStage workoutStage;

  const WorkoutStageCreatorStateSubmitted({
    required this.workoutStage,
  });

  @override
  List<Object> get props => [
        workoutStage,
      ];
}

abstract class WorkoutStageCreatorForm extends Equatable {
  const WorkoutStageCreatorForm();

  bool get areDataCorrect;

  WorkoutStageCreatorForm copyWith();
}

enum WorkoutStageType {
  baseRun,
  zone2,
  zone3,
  hillRepeats,
  rhythms,
  stretching,
  strengthening,
  foamRolling,
}
