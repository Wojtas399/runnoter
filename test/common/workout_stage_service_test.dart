import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/common/workout_stage_service.dart';
import 'package:runnoter/data/model/workout.dart';

void main() {
  test(
    'calculate distance of workout stage, '
    'distance stage, '
    'should simply return distance',
    () {
      const double expectedDistance = 10.0;
      const stage = WorkoutStageCardio(
        distanceInKm: expectedDistance,
        maxHeartRate: 150,
      );

      final double distance = calculateDistanceOfWorkoutStage(stage);

      expect(distance, expectedDistance);
    },
  );

  test(
    'calculate distance of workout stage, '
    'series stage, '
    'should sum series, walking and jogging distances and multiply by number of series',
    () {
      const stage = WorkoutStageHillRepeats(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        walkingDistanceInMeters: 20,
        joggingDistanceInMeters: 80,
      );
      const double expectedDistance = (10 * (100 + 20 + 80)) / 1000;

      final double distance = calculateDistanceOfWorkoutStage(stage);

      expect(distance, expectedDistance);
    },
  );
}
