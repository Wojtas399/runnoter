import '../../domain/model/workout_stage.dart';

double calculateTotalDistanceInKmOfSeriesWorkout(
  SeriesWorkoutStage stage,
) {
  final int distanceInMeters = stage.amountOfSeries *
      (stage.seriesDistanceInMeters +
          stage.breakMarchDistanceInMeters +
          stage.breakJogDistanceInMeters);
  return distanceInMeters / 1000;
}
