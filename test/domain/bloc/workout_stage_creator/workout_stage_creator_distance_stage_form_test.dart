import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/bloc/workout_stage_creator/workout_stage_creator_bloc.dart';

void main() {
  late WorkoutStageCreatorDistanceStageForm form;

  WorkoutStageCreatorDistanceStageForm createForm({
    double? distanceInKm,
    int? maxHeartRate,
  }) =>
      WorkoutStageCreatorDistanceStageForm(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

  setUp(() {
    form = createForm();
  });

  test(
    'are data correct, '
    'distance is higher than 0 and max heart rate is higher than 0, '
    'should be true',
    () {
      const double distanceInKm = 9.5;
      const int maxHeartRate = 150;

      form = createForm(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      expect(form.areDataCorrect, true);
    },
  );

  test(
    'are data correct, '
    'distance is null, '
    'should be false',
    () {
      const int maxHeartRate = 150;

      form = createForm(
        maxHeartRate: maxHeartRate,
      );

      expect(form.areDataCorrect, false);
    },
  );

  test(
    'are data correct, '
    'distance is lower or equal to 0, '
    'should be false',
    () {
      const double distanceInKm = 0;
      const int maxHeartRate = 150;

      form = createForm(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      expect(form.areDataCorrect, false);
    },
  );

  test(
    'are data correct, '
    'max heart rate is null, '
    'should be false',
    () {
      const double distanceInKm = 10.0;

      form = createForm(
        distanceInKm: distanceInKm,
      );

      expect(form.areDataCorrect, false);
    },
  );

  test(
    'are data correct, '
    'max heart rate is lower or equal to 0, '
    'should be false',
    () {
      const double distanceInKm = 10.0;
      const int maxHeartRate = 0;

      form = createForm(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

      expect(form.areDataCorrect, false);
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
