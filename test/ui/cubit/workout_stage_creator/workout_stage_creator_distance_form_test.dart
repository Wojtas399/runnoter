import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/model/workout.dart';
import 'package:runnoter/ui/cubit/workout_stage_creator/workout_stage_creator_cubit.dart';

void main() {
  late WorkoutStageCreatorDistanceForm form;
  const double distanceInKm = 9.5;
  const int maxHeartRate = 150;

  setUp(() {
    form = const WorkoutStageCreatorDistanceForm();
  });

  test(
    'canSubmit, '
    'distance is higher than 0 and max heart rate is higher than 0, '
    'should be true',
    () {
      form = const WorkoutStageCreatorDistanceForm(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      expect(form.canSubmit, true);
    },
  );

  test(
    'canSubmit, '
    'distance is null, '
    'should be false',
    () {
      form = const WorkoutStageCreatorDistanceForm(
        maxHeartRate: maxHeartRate,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'canSubmit, '
    'distance is lower than 0, '
    'should be false',
    () {
      form = const WorkoutStageCreatorDistanceForm(
        distanceInKm: -10,
        maxHeartRate: maxHeartRate,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'canSubmit, '
    'distance is equal to 0, '
    'should be false',
    () {
      form = const WorkoutStageCreatorDistanceForm(
        distanceInKm: 0,
        maxHeartRate: maxHeartRate,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'canSubmit, '
    'max heart rate is null, '
    'should be false',
    () {
      form = const WorkoutStageCreatorDistanceForm(
        distanceInKm: distanceInKm,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'canSubmit, '
    'max heart rate is lower than 0, '
    'should be false',
    () {
      form = const WorkoutStageCreatorDistanceForm(
        distanceInKm: distanceInKm,
        maxHeartRate: -10,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'canSubmit, '
    'max heart rate is equal to 0, '
    'should be false',
    () {
      form = const WorkoutStageCreatorDistanceForm(
        distanceInKm: distanceInKm,
        maxHeartRate: 0,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'canSubmit, '
    'distance is different than original, '
    'should be true',
    () {
      const DistanceWorkoutStage originalStage = WorkoutStageCardio(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      form = const WorkoutStageCreatorDistanceForm(
        originalStage: originalStage,
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate + 10,
      );

      expect(form.canSubmit, true);
    },
  );

  test(
    'canSubmit, '
    'max heart rate is different than original, '
    'should be true',
    () {
      const DistanceWorkoutStage originalStage = WorkoutStageCardio(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      form = const WorkoutStageCreatorDistanceForm(
        originalStage: originalStage,
        distanceInKm: distanceInKm + 5,
        maxHeartRate: maxHeartRate,
      );

      expect(form.canSubmit, true);
    },
  );

  test(
    'canSubmit, '
    'distance and max heart rate are same as original, '
    'should be false',
    () {
      const DistanceWorkoutStage originalStage = WorkoutStageCardio(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      form = const WorkoutStageCreatorDistanceForm(
        originalStage: originalStage,
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'copy with distanceInKm, '
    'should copy current value if new value is null',
    () {
      const double expected = 10.0;

      form = form.copyWith(distanceInKm: expected);
      final form2 = form.copyWith();

      expect(form.distanceInKm, expected);
      expect(form2.distanceInKm, expected);
    },
  );

  test(
    'copy with maxHeartRate, '
    'should copy current value if new value is null',
    () {
      const int expected = 150;

      form = form.copyWith(maxHeartRate: expected);
      final form2 = form.copyWith();

      expect(form.maxHeartRate, expected);
      expect(form2.maxHeartRate, expected);
    },
  );
}
