part of 'workout_stage_creator_bloc.dart';

class WorkoutStageCreatorSeriesStageForm extends WorkoutStageCreatorForm {
  final SeriesWorkoutStage? originalStage;
  final int? amountOfSeries;
  final int? seriesDistanceInMeters;
  final int? walkingDistanceInMeters;
  final int? joggingDistanceInMeters;

  const WorkoutStageCreatorSeriesStageForm({
    required this.originalStage,
    required this.amountOfSeries,
    required this.seriesDistanceInMeters,
    required this.walkingDistanceInMeters,
    required this.joggingDistanceInMeters,
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
  bool get isSubmitButtonDisabled =>
      _areDataIncorrect || _areDataSameAsOriginal;

  bool get _areDataIncorrect =>
      _isAmountOfSeriesIncorrect ||
      _isSeriesDistanceInMetersIncorrect ||
      _isBreakDistanceIncorrect;

  bool get _areDataSameAsOriginal =>
      amountOfSeries == originalStage?.amountOfSeries &&
      seriesDistanceInMeters == originalStage?.seriesDistanceInMeters &&
      walkingDistanceInMeters == originalStage?.walkingDistanceInMeters &&
      joggingDistanceInMeters == originalStage?.joggingDistanceInMeters;

  bool get _isAmountOfSeriesIncorrect =>
      amountOfSeries == null || amountOfSeries! <= 0;

  bool get _isSeriesDistanceInMetersIncorrect =>
      seriesDistanceInMeters == null || seriesDistanceInMeters! <= 0;

  bool get _isBreakDistanceIncorrect {
    if (walkingDistanceInMeters != null && joggingDistanceInMeters != null) {
      return walkingDistanceInMeters! < 0 ||
          joggingDistanceInMeters! < 0 ||
          (walkingDistanceInMeters! == 0 && joggingDistanceInMeters! == 0);
    } else if (walkingDistanceInMeters != null) {
      return walkingDistanceInMeters! <= 0;
    } else if (joggingDistanceInMeters != null) {
      return joggingDistanceInMeters! <= 0;
    }
    return false;
  }

  @override
  WorkoutStageCreatorSeriesStageForm copyWith({
    int? amountOfSeries,
    int? seriesDistanceInMeters,
    int? walkingDistanceInMeters,
    int? joggingDistanceInMeters,
  }) =>
      WorkoutStageCreatorSeriesStageForm(
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
