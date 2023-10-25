part of 'workout_stage_creator_cubit.dart';

class WorkoutStageCreatorState extends Equatable {
  final WorkoutStageType? originalStageType;
  final WorkoutStageType? stageType;
  final WorkoutStageCreatorDistanceForm distanceForm;
  final WorkoutStageCreatorSeriesForm seriesForm;
  final WorkoutStage? stageToAdd;

  const WorkoutStageCreatorState({
    this.originalStageType,
    this.stageType,
    this.distanceForm = const WorkoutStageCreatorDistanceForm(),
    this.seriesForm = const WorkoutStageCreatorSeriesForm(),
    this.stageToAdd,
  });

  @override
  List<Object?> get props => [
        originalStageType,
        stageType,
        distanceForm,
        seriesForm,
        stageToAdd,
      ];

  bool get isEditMode =>
      distanceForm.originalStage != null || seriesForm.originalStage != null;

  bool get canSubmit {
    if (originalStageType != null && stageType != originalStageType) {
      return true;
    }
    return stageType != null &&
        ((isDistanceStage && distanceForm.canSubmit) ||
            (isSeriesStage && seriesForm.canSubmit));
  }

  bool get isDistanceStage =>
      stageType == WorkoutStageType.cardio ||
      stageType == WorkoutStageType.zone2 ||
      stageType == WorkoutStageType.zone3;

  bool get isSeriesStage =>
      stageType == WorkoutStageType.hillRepeats ||
      stageType == WorkoutStageType.rhythms;

  WorkoutStageCreatorState copyWith({
    WorkoutStageType? originalStageType,
    WorkoutStageType? stageType,
    WorkoutStageCreatorDistanceForm? distanceForm,
    WorkoutStageCreatorSeriesForm? seriesForm,
    WorkoutStage? stageToAdd,
  }) =>
      WorkoutStageCreatorState(
        originalStageType: originalStageType ?? this.originalStageType,
        stageType: stageType ?? this.stageType,
        distanceForm: distanceForm ?? this.distanceForm,
        seriesForm: seriesForm ?? this.seriesForm,
        stageToAdd: stageToAdd,
      );
}

abstract class WorkoutStageCreatorForm extends Equatable {
  const WorkoutStageCreatorForm();

  bool get canSubmit;

  WorkoutStageCreatorForm copyWith();
}

enum WorkoutStageType { cardio, zone2, zone3, hillRepeats, rhythms }
