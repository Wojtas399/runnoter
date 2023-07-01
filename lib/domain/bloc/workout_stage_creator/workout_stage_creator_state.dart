part of 'workout_stage_creator_bloc.dart';

class WorkoutStageCreatorState extends BlocState<WorkoutStageCreatorState> {
  final WorkoutStageType? stageType;
  final WorkoutStageCreatorDistanceForm distanceForm;
  final WorkoutStageCreatorSeriesForm seriesForm;
  final WorkoutStage? stageToSubmit;

  const WorkoutStageCreatorState({
    required super.status,
    this.stageType,
    this.distanceForm = const WorkoutStageCreatorDistanceForm(),
    this.seriesForm = const WorkoutStageCreatorSeriesForm(),
    this.stageToSubmit,
  });

  @override
  List<Object?> get props => [
        status,
        stageType,
        distanceForm,
        seriesForm,
        stageToSubmit,
      ];

  bool get isSubmitButtonDisabled =>
      stageType == null ||
      (isDistanceStage && distanceForm.isSubmitButtonDisabled) ||
      (isSeriesStage && seriesForm.isSubmitButtonDisabled);

  bool get isDistanceStage =>
      stageType == WorkoutStageType.cardio ||
      stageType == WorkoutStageType.zone2 ||
      stageType == WorkoutStageType.zone3;

  bool get isSeriesStage =>
      stageType == WorkoutStageType.hillRepeats ||
      stageType == WorkoutStageType.rhythms;

  @override
  WorkoutStageCreatorState copyWith({
    BlocStatus? status,
    WorkoutStageType? stageType,
    WorkoutStageCreatorDistanceForm? distanceForm,
    WorkoutStageCreatorSeriesForm? seriesForm,
    WorkoutStage? stageToSubmit,
  }) =>
      WorkoutStageCreatorState(
        status: status ?? const BlocStatusComplete(),
        stageType: stageType ?? this.stageType,
        distanceForm: distanceForm ?? this.distanceForm,
        seriesForm: seriesForm ?? this.seriesForm,
        stageToSubmit: stageToSubmit,
      );
}

abstract class WorkoutStageCreatorForm extends Equatable {
  const WorkoutStageCreatorForm();

  bool get isSubmitButtonDisabled;

  WorkoutStageCreatorForm copyWith();
}

enum WorkoutStageType {
  cardio,
  zone2,
  zone3,
  hillRepeats,
  rhythms,
}
