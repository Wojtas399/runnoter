part of 'workout_stage_creator_cubit.dart';

class WorkoutStageCreatorSeriesForm extends WorkoutStageCreatorForm {
  final SeriesWorkoutStage? originalStage;
  final int? amountOfSeries;
  final int? seriesDistanceInMeters;
  final int? walkingDistanceInMeters;
  final int? joggingDistanceInMeters;

  const WorkoutStageCreatorSeriesForm({
    this.originalStage,
    this.amountOfSeries,
    this.seriesDistanceInMeters,
    this.walkingDistanceInMeters,
    this.joggingDistanceInMeters,
  });

  @override
  List<Object?> get props => [
        originalStage,
        amountOfSeries,
        seriesDistanceInMeters,
        walkingDistanceInMeters,
        joggingDistanceInMeters,
      ];

  @override
  bool get canSubmit => _areDataCorrect && _areDataDifferentThanOriginal;

  bool get _areDataCorrect =>
      _isAmountOfSeriesCorrect &&
      _isSeriesDistanceInMetersCorrect &&
      _isBreakDistanceCorrect;

  bool get _areDataDifferentThanOriginal =>
      amountOfSeries != originalStage?.amountOfSeries ||
      seriesDistanceInMeters != originalStage?.seriesDistanceInMeters ||
      walkingDistanceInMeters != originalStage?.walkingDistanceInMeters ||
      joggingDistanceInMeters != originalStage?.joggingDistanceInMeters;

  bool get _isAmountOfSeriesCorrect =>
      amountOfSeries != null && amountOfSeries! > 0;

  bool get _isSeriesDistanceInMetersCorrect =>
      seriesDistanceInMeters != null && seriesDistanceInMeters! > 0;

  bool get _isBreakDistanceCorrect {
    if (walkingDistanceInMeters != null && joggingDistanceInMeters != null) {
      return walkingDistanceInMeters! >= 0 &&
          joggingDistanceInMeters! >= 0 &&
          (walkingDistanceInMeters! != 0 || joggingDistanceInMeters! != 0);
    } else if (walkingDistanceInMeters != null) {
      return walkingDistanceInMeters! > 0;
    } else if (joggingDistanceInMeters != null) {
      return joggingDistanceInMeters! > 0;
    }
    return false;
  }

  @override
  WorkoutStageCreatorSeriesForm copyWith({
    int? amountOfSeries,
    int? seriesDistanceInMeters,
    int? walkingDistanceInMeters,
    int? joggingDistanceInMeters,
  }) =>
      WorkoutStageCreatorSeriesForm(
        originalStage: originalStage,
        amountOfSeries: amountOfSeries ?? this.amountOfSeries,
        seriesDistanceInMeters:
            seriesDistanceInMeters ?? this.seriesDistanceInMeters,
        walkingDistanceInMeters:
            walkingDistanceInMeters ?? this.walkingDistanceInMeters,
        joggingDistanceInMeters:
            joggingDistanceInMeters ?? this.joggingDistanceInMeters,
      );
}
