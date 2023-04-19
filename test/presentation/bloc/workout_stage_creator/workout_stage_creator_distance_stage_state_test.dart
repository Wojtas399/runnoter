import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/presentation/screen/workout_stage_creator/bloc/workout_stage_creator_distance_stage_state.dart';

void main() {
  late WorkoutStageCreatorDistanceStageState state;

  WorkoutStageCreatorDistanceStageState createState({
    double? distanceInKm,
    int? maxHeartRate,
  }) =>
      WorkoutStageCreatorDistanceStageState(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

  setUp(() {
    state = createState();
  });

  test(
    'are data correct, '
    'distance is higher than 0 and max heart rate is higher than 0, '
    'should be true',
    () {
      const double distanceInKm = 9.5;
      const int maxHeartRate = 150;

      state = createState(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      expect(state.areDataCorrect, true);
    },
  );

  test(
    'are data correct, '
    'distance is null, '
    'should be false',
    () {
      const int maxHeartRate = 150;

      state = createState(
        maxHeartRate: maxHeartRate,
      );

      expect(state.areDataCorrect, false);
    },
  );

  test(
    'are data correct, '
    'distance is lower or equal to 0, '
    'should be false',
    () {
      const double distanceInKm = 0;
      const int maxHeartRate = 150;

      state = createState(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      expect(state.areDataCorrect, false);
    },
  );

  test(
    'are data correct, '
    'max heart rate is null, '
    'should be false',
    () {
      const double distanceInKm = 10.0;

      state = createState(
        distanceInKm: distanceInKm,
      );

      expect(state.areDataCorrect, false);
    },
  );

  test(
    'are data correct, '
    'max heart rate is lower or equal to 0, '
    'should be false',
    () {
      const double distanceInKm = 10.0;
      const int maxHeartRate = 0;

      state = createState(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      expect(state.areDataCorrect, false);
    },
  );

  test(
    'copy with distance in km',
    () {
      const double expectedDistanceInKm = 10.0;

      state = state.copyWith(distanceInKm: expectedDistanceInKm);
      final state2 = state.copyWith();

      expect(state.distanceInKm, expectedDistanceInKm);
      expect(state2.distanceInKm, expectedDistanceInKm);
    },
  );

  test(
    'copy with max heart rate',
    () {
      const int expectedMaxHeartRate = 150;

      state = state.copyWith(maxHeartRate: expectedMaxHeartRate);
      final state2 = state.copyWith();

      expect(state.maxHeartRate, expectedMaxHeartRate);
      expect(state2.maxHeartRate, expectedMaxHeartRate);
    },
  );
}
