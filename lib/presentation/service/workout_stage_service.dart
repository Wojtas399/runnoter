import '../../domain/model/workout_stage.dart';

int calculateTotalDistanceOfSeriesWorkout(SeriesWorkout seriesWorkout) {
  return seriesWorkout.amountOfSeries *
      (seriesWorkout.seriesDistanceInMeters +
          seriesWorkout.breakMarchDistanceInMeters +
          seriesWorkout.breakJogDistanceInMeters);
}
