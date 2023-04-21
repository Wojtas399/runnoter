part of 'workout_stage_creator_bloc.dart';

class WorkoutStageCreatorState extends BlocState<WorkoutStageCreatorState> {
  final WorkoutStage? stageType;
  final WorkoutStageCreatorForm? form;

  const WorkoutStageCreatorState({
    required super.status,
    required this.stageType,
    required this.form,
  });

  @override
  List<Object?> get props => [
        status,
        stageType,
        form,
      ];

  bool get isAddButtonDisabled {
    print(form?.areDataCorrect);
    return stageType == null || (form != null ? !form!.areDataCorrect : false);
  }

  @override
  WorkoutStageCreatorState copyWith({
    BlocStatus? status,
    WorkoutStage? stageType,
    WorkoutStageCreatorForm? form,
  }) =>
      WorkoutStageCreatorState(
        status: status ?? const BlocStatusComplete(),
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
