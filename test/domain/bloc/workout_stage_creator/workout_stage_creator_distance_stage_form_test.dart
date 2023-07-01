import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/bloc/workout_stage_creator/workout_stage_creator_bloc.dart';
import 'package:runnoter/domain/entity/workout_stage.dart';

void main() {
  late WorkoutStageCreatorDistanceStageForm form;
  const double distanceInKm = 9.5;
  const int maxHeartRate = 150;

  WorkoutStageCreatorDistanceStageForm createForm({
    DistanceWorkoutStage? originalStage,
    double? distanceInKm,
    int? maxHeartRate,
  }) =>
      WorkoutStageCreatorDistanceStageForm(
        originalStage: originalStage,
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

  setUp(() {
    form = createForm();
  });

  test(
    'is submit button disabled, '
    'distance is higher than 0 and max heart rate is higher than 0, '
    'should be false',
    () {
      form = createForm(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      expect(form.isSubmitButtonDisabled, false);
    },
  );

  test(
    'is submit button disabled, '
    'distance is null, '
    'should be true',
    () {
      form = createForm(
        maxHeartRate: maxHeartRate,
      );

      expect(form.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'distance is lower than 0, '
    'should be true',
    () {
      form = createForm(
        distanceInKm: -10,
        maxHeartRate: maxHeartRate,
      );

      expect(form.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'distance is equal to 0, '
    'should be true',
    () {
      form = createForm(
        distanceInKm: 0,
        maxHeartRate: maxHeartRate,
      );

      expect(form.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'max heart rate is null, '
    'should be true',
    () {
      form = createForm(
        distanceInKm: distanceInKm,
      );

      expect(form.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'max heart rate is lower than 0, '
    'should be true',
    () {
      form = createForm(
        distanceInKm: distanceInKm,
        maxHeartRate: -10,
      );

      expect(form.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'max heart rate is equal to 0, '
    'should be true',
    () {
      form = createForm(
        distanceInKm: distanceInKm,
        maxHeartRate: 0,
      );

      expect(form.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'distance is different than original, '
    'should be false',
    () {
      const DistanceWorkoutStage originalStage = WorkoutStageBaseRun(
        distanceInKilometers: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      form = createForm(
        originalStage: originalStage,
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate + 10,
      );

      expect(form.isSubmitButtonDisabled, false);
    },
  );

  test(
    'is submit button disabled, '
    'max heart rate is different than original, '
    'should be false',
    () {
      const DistanceWorkoutStage originalStage = WorkoutStageBaseRun(
        distanceInKilometers: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      form = createForm(
        originalStage: originalStage,
        distanceInKm: distanceInKm + 5,
        maxHeartRate: maxHeartRate,
      );

      expect(form.isSubmitButtonDisabled, false);
    },
  );

  test(
    'is submit button disabled, '
    'distance and max heart rate are same as original, '
    'should be true',
    () {
      const DistanceWorkoutStage originalStage = WorkoutStageBaseRun(
        distanceInKilometers: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
      form = createForm(
        originalStage: originalStage,
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      expect(form.isSubmitButtonDisabled, true);
    },
  );

  test(
    'copy with distance in km',
    () {
      const double expectedDistanceInKm = 10.0;

      form = form.copyWith(distanceInKm: expectedDistanceInKm);
      final form2 = form.copyWith();

      expect(form.distanceInKm, expectedDistanceInKm);
      expect(form2.distanceInKm, expectedDistanceInKm);
    },
  );

  test(
    'copy with max heart rate',
    () {
      const int expectedMaxHeartRate = 150;

      form = form.copyWith(maxHeartRate: expectedMaxHeartRate);
      final form2 = form.copyWith();

      expect(form.maxHeartRate, expectedMaxHeartRate);
      expect(form2.maxHeartRate, expectedMaxHeartRate);
    },
  );
}
