import '../../domain/model/workout_stage.dart';

double calculateTotalDistanceInKmOfSeriesWorkout(
  SeriesWorkoutStage stage,
) {
  final int distanceInMeters = stage.amountOfSeries *
      (stage.seriesDistanceInMeters +
          stage.walkingDistanceInMeters +
          stage.joggingDistanceInMeters);
  return distanceInMeters / 1000;
}
