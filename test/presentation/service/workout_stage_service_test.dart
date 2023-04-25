import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/model/workout_stage.dart';
import 'package:runnoter/presentation/service/workout_stage_service.dart';

void main() {
  test(
    'calculate total distance of series workout, '
    'should sum series, marching and jogging distances and multiply result by amount of series',
    () {
      final seriesWorkoutStage = WorkoutStageHillRepeats(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        breakMarchDistanceInMeters: 20,
        breakJogDistanceInMeters: 80,
      );
      const double expectedTotalDistance = (10 * (100 + 20 + 80)) / 1000;

      final double totalDistance = calculateTotalDistanceInKmOfSeriesWorkout(
        seriesWorkoutStage,
      );

      expect(totalDistance, expectedTotalDistance);
    },
  );
}
