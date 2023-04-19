import '../../../model/bloc_status.dart';
import 'workout_stage_creator_state.dart';

class WorkoutStageCreatorSeriesStageState extends WorkoutStageCreatorState {
  final int? amountOfSeries;
  final int? seriesDistanceInMeters;
  final int? breakWalkingDistanceInMeters;
  final int? breakJoggingDistanceInMeters;

  const WorkoutStageCreatorSeriesStageState({
    required super.status,
    required this.amountOfSeries,
    required this.seriesDistanceInMeters,
    required this.breakWalkingDistanceInMeters,
    required this.breakJoggingDistanceInMeters,
  });

  @override
  List<Object?> get props => [
        amountOfSeries,
        seriesDistanceInMeters,
        breakWalkingDistanceInMeters,
        breakJoggingDistanceInMeters,
      ];

  @override
  bool get areDataCorrect =>
      _isAmountOfSeriesCorrect &&
      _isSeriesDistanceInMetersCorrect &&
      (_isBreakWalkingDistanceInMetersCorrect ||
          _isBreakJoggingDistanceInMetersCorrect);

  bool get _isAmountOfSeriesCorrect =>
      amountOfSeries != null && amountOfSeries! > 0;

  bool get _isSeriesDistanceInMetersCorrect =>
      seriesDistanceInMeters != null && seriesDistanceInMeters! > 0;

  bool get _isBreakWalkingDistanceInMetersCorrect =>
      breakWalkingDistanceInMeters != null && breakWalkingDistanceInMeters! > 0;

  bool get _isBreakJoggingDistanceInMetersCorrect =>
      breakJoggingDistanceInMeters != null && breakJoggingDistanceInMeters! > 0;

  @override
  WorkoutStageCreatorSeriesStageState copyWith({
    BlocStatus? status,
    int? amountOfSeries,
    int? seriesDistanceInMeters,
    int? breakWalkingDistanceInMeters,
    int? breakJoggingDistanceInMeters,
  }) =>
      WorkoutStageCreatorSeriesStageState(
        status: status ?? const BlocStatusComplete(),
        amountOfSeries: amountOfSeries ?? this.amountOfSeries,
        seriesDistanceInMeters:
            seriesDistanceInMeters ?? this.seriesDistanceInMeters,
        breakWalkingDistanceInMeters:
            breakWalkingDistanceInMeters ?? this.breakWalkingDistanceInMeters,
        breakJoggingDistanceInMeters:
            breakJoggingDistanceInMeters ?? this.breakJoggingDistanceInMeters,
      );
}
