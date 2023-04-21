part of 'workout_stage_creator_bloc.dart';

class WorkoutStageCreatorState extends BlocState<WorkoutStageCreatorState> {
  final WorkoutStageCreatorForm? form;

  const WorkoutStageCreatorState({
    required super.status,
    required this.form,
  });

  @override
  List<Object?> get props => [
        status,
        form,
      ];

  @override
  WorkoutStageCreatorState copyWith({
    BlocStatus? status,
    WorkoutStageCreatorForm? form,
  }) =>
      WorkoutStageCreatorState(
        status: status ?? const BlocStatusComplete(),
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
