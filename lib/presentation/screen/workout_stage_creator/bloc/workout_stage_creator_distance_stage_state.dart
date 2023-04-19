import '../../../model/bloc_status.dart';
import 'workout_stage_creator_state.dart';

class WorkoutStageCreatorDistanceStageState extends WorkoutStageCreatorState {
  final double? distanceInKm;
  final int? maxHeartRate;

  const WorkoutStageCreatorDistanceStageState({
    required super.status,
    required this.distanceInKm,
    required this.maxHeartRate,
  });

  @override
  List<Object?> get props => [
        status,
        distanceInKm,
        maxHeartRate,
      ];

  @override
  bool get areDataCorrect => _isDistanceInKmCorrect && _isMaxHeartRateCorrect;

  bool get _isDistanceInKmCorrect => distanceInKm != null && distanceInKm! > 0;

  bool get _isMaxHeartRateCorrect => maxHeartRate != null && maxHeartRate! > 0;

  @override
  WorkoutStageCreatorDistanceStageState copyWith({
    BlocStatus? status,
    double? distanceInKm,
    int? maxHeartRate,
  }) =>
      WorkoutStageCreatorDistanceStageState(
        status: status ?? const BlocStatusComplete(),
        distanceInKm: distanceInKm ?? this.distanceInKm,
        maxHeartRate: maxHeartRate ?? this.maxHeartRate,
      );
}
