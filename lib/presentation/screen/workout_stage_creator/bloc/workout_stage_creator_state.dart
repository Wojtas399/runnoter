part of 'workout_stage_creator_bloc.dart';

abstract class WorkoutStageCreatorState extends Equatable {
  const WorkoutStageCreatorState();
}

class WorkoutStageCreatorStateInProgress extends WorkoutStageCreatorState {
  final WorkoutStage? stageType;
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
    WorkoutStage? stageType,
    WorkoutStageCreatorForm? form,
  }) =>
      WorkoutStageCreatorStateInProgress(
        stageType: stageType ?? this.stageType,
        form: form,
      );
}

abstract class WorkoutStageCreatorForm extends Equatable {
  const WorkoutStageCreatorForm();

  bool get areDataCorrect;

  WorkoutStageCreatorForm copyWith();
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
