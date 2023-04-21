part of 'workout_stage_creator_bloc.dart';

class WorkoutStageCreatorState extends Equatable {
  final WorkoutStage? stageType;
  final WorkoutStageCreatorForm? form;

  const WorkoutStageCreatorState({
    required this.stageType,
    required this.form,
  });

  @override
  List<Object?> get props => [
        stageType,
        form,
      ];

  bool get isAddButtonDisabled {
    print(form?.areDataCorrect);
    return stageType == null || (form != null ? !form!.areDataCorrect : false);
  }

  WorkoutStageCreatorState copyWith({
    WorkoutStage? stageType,
    WorkoutStageCreatorForm? form,
  }) =>
      WorkoutStageCreatorState(
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
