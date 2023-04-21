import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/presentation/screen/workout_stage_creator/bloc/workout_stage_creator_bloc.dart';

void main() {
  late WorkoutStageCreatorSeriesStageForm form;

  WorkoutStageCreatorSeriesStageForm createForm({
    int? amountOfSeries,
    int? seriesDistanceInMeters,
    int? breakWalkingDistanceInMeters,
    int? breakJoggingDistanceInMeters,
  }) =>
      WorkoutStageCreatorSeriesStageForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakWalkingDistanceInMeters: breakWalkingDistanceInMeters,
        breakJoggingDistanceInMeters: breakJoggingDistanceInMeters,
      );

  test(
    'are data correct, '
    'amount of series is higher than 0, '
    'series distance in meters is higher than 0, '
    'break walking distance is higher than 0, '
    'should be true',
    () {
      const int amountOfSeries = 10;
      const int seriesDistanceInMeters = 100;
      const int breakWalkingDistanceInMeters = 100;

      form = createForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakWalkingDistanceInMeters: breakWalkingDistanceInMeters,
      );

      expect(form.areDataCorrect, true);
    },
  );

  test(
    'are data correct, '
    'amount of series is higher than 0, '
    'series distance in meters is higher than 0, '
    'break jogging distance is higher than 0, '
    'should be true',
    () {
      const int amountOfSeries = 10;
      const int seriesDistanceInMeters = 100;
      const int breakJoggingDistanceInMeters = 100;

      form = createForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakJoggingDistanceInMeters: breakJoggingDistanceInMeters,
      );

      expect(form.areDataCorrect, true);
    },
  );

  test(
    'are data correct, '
    'amount of series is null, '
    'should be false',
    () {
      const int seriesDistanceInMeters = 100;
      const int breakJoggingDistanceInMeters = 100;

      form = createForm(
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakJoggingDistanceInMeters: breakJoggingDistanceInMeters,
      );

      expect(form.areDataCorrect, false);
    },
  );

  test(
    'are data correct, '
    'amount of series is 0, '
    'should be false',
    () {
      const int amountOfSeries = 0;
      const int seriesDistanceInMeters = 100;
      const int breakJoggingDistanceInMeters = 100;

      form = createForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakJoggingDistanceInMeters: breakJoggingDistanceInMeters,
      );

      expect(form.areDataCorrect, false);
    },
  );

  test(
    'are data correct, '
    'series distance in meters is null, '
    'should be false',
    () {
      const int amountOfSeries = 10;
      const int breakJoggingDistanceInMeters = 100;

      form = createForm(
        amountOfSeries: amountOfSeries,
        breakJoggingDistanceInMeters: breakJoggingDistanceInMeters,
      );

      expect(form.areDataCorrect, false);
    },
  );

  test(
    'are data correct, '
    'series distance in meters is 0, '
    'should be false',
    () {
      const int amountOfSeries = 10;
      const seriesDistanceInMeters = 0;
      const int breakJoggingDistanceInMeters = 100;

      form = createForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakJoggingDistanceInMeters: breakJoggingDistanceInMeters,
      );

      expect(form.areDataCorrect, false);
    },
  );

  test(
    'are data correct, '
    'break walking and jogging distances are 0, '
    'should be false',
    () {
      const int amountOfSeries = 10;
      const int seriesDistanceInMeters = 100;
      const int breakWalkingDistanceInMeters = 0;
      const int breakJoggingDistanceInMeters = 0;

      form = createForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakWalkingDistanceInMeters: breakWalkingDistanceInMeters,
        breakJoggingDistanceInMeters: breakJoggingDistanceInMeters,
      );

      expect(form.areDataCorrect, false);
    },
  );

  test(
    'copy with amount of series',
    () {
      const int expectedAmountOfSeries = 10;

      form = form.copyWith(amountOfSeries: expectedAmountOfSeries);
      final form2 = form.copyWith();

      expect(form.amountOfSeries, expectedAmountOfSeries);
      expect(form2.amountOfSeries, expectedAmountOfSeries);
    },
  );

  test(
    'copy with series distance in meters',
    () {
      const int expectedSeriesDistanceInMeters = 100;

      form = form.copyWith(
        seriesDistanceInMeters: expectedSeriesDistanceInMeters,
      );
      final form2 = form.copyWith();

      expect(form.seriesDistanceInMeters, expectedSeriesDistanceInMeters);
      expect(form2.seriesDistanceInMeters, expectedSeriesDistanceInMeters);
    },
  );

  test(
    'copy with break walking distance in meters',
    () {
      const int expectedBreakWalkingDistanceInMeters = 20;

      form = form.copyWith(
        breakWalkingDistanceInMeters: expectedBreakWalkingDistanceInMeters,
      );
      final form2 = form.copyWith();

      expect(
        form.breakWalkingDistanceInMeters,
        expectedBreakWalkingDistanceInMeters,
      );
      expect(
        form2.breakWalkingDistanceInMeters,
        expectedBreakWalkingDistanceInMeters,
      );
    },
  );

  test(
    'copy with break jogging distance in meters',
    () {
      const int expectedBreakJoggingDistanceInMeters = 80;

      form = form.copyWith(
        breakJoggingDistanceInMeters: expectedBreakJoggingDistanceInMeters,
      );
      final form2 = form.copyWith();

      expect(
        form.breakJoggingDistanceInMeters,
        expectedBreakJoggingDistanceInMeters,
      );
      expect(
        form2.breakJoggingDistanceInMeters,
        expectedBreakJoggingDistanceInMeters,
      );
    },
  );
}
