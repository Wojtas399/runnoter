part of 'workout_stage_creator_bloc.dart';

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
  List<Object?> get props => [
        originalStage,
        distanceInKm,
        maxHeartRate,
      ];

  @override
  bool get isSubmitButtonDisabled =>
      _areDataIncorrect || _areDataSameAsOriginal;

  bool get _areDataSameAsOriginal =>
      distanceInKm == originalStage?.distanceInKilometers &&
      maxHeartRate == originalStage?.maxHeartRate;

  bool get _areDataIncorrect =>
      _isDistanceInKmIncorrect || _isMaxHeartRateIncorrect;

  bool get _isDistanceInKmIncorrect =>
      distanceInKm == null || distanceInKm! <= 0;

  bool get _isMaxHeartRateIncorrect =>
      maxHeartRate == null || maxHeartRate! <= 0;

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
