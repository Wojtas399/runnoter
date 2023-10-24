part of 'workout_stage_creator_cubit.dart';

class WorkoutStageCreatorDistanceForm extends WorkoutStageCreatorForm {
  final DistanceWorkoutStage? originalStage;
  final double? distanceInKm;
  final int? maxHeartRate;

  const WorkoutStageCreatorDistanceForm({
    this.originalStage,
    this.distanceInKm,
    this.maxHeartRate,
  });

  @override
  List<Object?> get props => [originalStage, distanceInKm, maxHeartRate];

  @override
  bool get canSubmit =>
      _areDataCorrect && _areDataDifferentThanOriginalOriginal;

  bool get _areDataDifferentThanOriginalOriginal =>
      distanceInKm != originalStage?.distanceInKm ||
      maxHeartRate != originalStage?.maxHeartRate;

  bool get _areDataCorrect => _isDistanceInKmCorrect && _isMaxHeartRateCorrect;

  bool get _isDistanceInKmCorrect => distanceInKm != null && distanceInKm! > 0;

  bool get _isMaxHeartRateCorrect => maxHeartRate != null && maxHeartRate! > 0;

  @override
  WorkoutStageCreatorDistanceForm copyWith({
    double? distanceInKm,
    int? maxHeartRate,
  }) =>
      WorkoutStageCreatorDistanceForm(
        originalStage: originalStage,
        distanceInKm: distanceInKm ?? this.distanceInKm,
        maxHeartRate: maxHeartRate ?? this.maxHeartRate,
      );
}
