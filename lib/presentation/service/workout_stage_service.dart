import '../../domain/entity/workout_stage.dart';

double calculateDistanceOfWorkoutStage(WorkoutStage stage) {
  if (stage is DistanceWorkoutStage) {
    return stage.distanceInKilometers;
  } else if (stage is SeriesWorkoutStage) {
    final int distanceInMeters = stage.amountOfSeries *
        (stage.seriesDistanceInMeters +
            stage.walkingDistanceInMeters +
            stage.joggingDistanceInMeters);
    return distanceInMeters / 1000;
  }
  return 0.0;
}
