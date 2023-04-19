import 'workout_stage_creator_state.dart';

class WorkoutStageCreatorDistanceStageState extends WorkoutStageCreatorState {
  final double? distanceInKm;
  final int? maxHeartRate;

  const WorkoutStageCreatorDistanceStageState({
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
  WorkoutStageCreatorDistanceStageState copyWith({
    double? distanceInKm,
    int? maxHeartRate,
  }) =>
      WorkoutStageCreatorDistanceStageState(
        distanceInKm: distanceInKm ?? this.distanceInKm,
        maxHeartRate: maxHeartRate ?? this.maxHeartRate,
      );
}
