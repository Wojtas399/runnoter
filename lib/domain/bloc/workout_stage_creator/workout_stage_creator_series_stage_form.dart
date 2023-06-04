part of 'workout_stage_creator_bloc.dart';

class WorkoutStageCreatorSeriesStageForm extends WorkoutStageCreatorForm {
  final int? amountOfSeries;
  final int? seriesDistanceInMeters;
  final int? breakWalkingDistanceInMeters;
  final int? breakJoggingDistanceInMeters;

  const WorkoutStageCreatorSeriesStageForm({
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
  WorkoutStageCreatorSeriesStageForm copyWith({
    int? amountOfSeries,
    int? seriesDistanceInMeters,
    int? breakWalkingDistanceInMeters,
    int? breakJoggingDistanceInMeters,
  }) =>
      WorkoutStageCreatorSeriesStageForm(
        amountOfSeries: amountOfSeries ?? this.amountOfSeries,
        seriesDistanceInMeters:
            seriesDistanceInMeters ?? this.seriesDistanceInMeters,
        breakWalkingDistanceInMeters:
            breakWalkingDistanceInMeters ?? this.breakWalkingDistanceInMeters,
        breakJoggingDistanceInMeters:
            breakJoggingDistanceInMeters ?? this.breakJoggingDistanceInMeters,
      );
}
