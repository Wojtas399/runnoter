part of 'workout_stage_creator_bloc.dart';

class WorkoutStageCreatorDistanceStageForm extends WorkoutStageCreatorForm {
  final double? distanceInKm;
  final int? maxHeartRate;

  const WorkoutStageCreatorDistanceStageForm({
    required this.distanceInKm,
    required this.maxHeartRate,
  });

  @override
  List<Object?> get props => [
        distanceInKm,
        maxHeartRate,
      ];

  @override
  bool get areDataCorrect => _isDistanceInKmCorrect && _isMaxHeartRateCorrect;

  bool get _isDistanceInKmCorrect => distanceInKm != null && distanceInKm! > 0;

  bool get _isMaxHeartRateCorrect => maxHeartRate != null && maxHeartRate! > 0;

  @override
  WorkoutStageCreatorDistanceStageForm copyWith({
    double? distanceInKm,
    int? maxHeartRate,
  }) =>
      WorkoutStageCreatorDistanceStageForm(
        distanceInKm: distanceInKm ?? this.distanceInKm,
        maxHeartRate: maxHeartRate ?? this.maxHeartRate,
      );
}
