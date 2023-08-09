import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/workout_stage.dart';
import 'package:runnoter/domain/bloc/workout_stage_creator/workout_stage_creator_bloc.dart';

void main() {
  late WorkoutStageCreatorSeriesForm form;
  const int amountOfSeries = 10;
  const int seriesDistanceInMeters = 100;
  const int walkingDistanceInMeters = 100;
  const int joggingDistanceInMeters = 100;
  const SeriesWorkoutStage originalStage = WorkoutStageRhythms(
    amountOfSeries: amountOfSeries,
    seriesDistanceInMeters: seriesDistanceInMeters,
    walkingDistanceInMeters: walkingDistanceInMeters,
    joggingDistanceInMeters: joggingDistanceInMeters,
  );

  WorkoutStageCreatorSeriesForm createForm({
    SeriesWorkoutStage? originalStage,
    int? amountOfSeries,
    int? seriesDistanceInMeters,
    int? walkingDistanceInMeters,
    int? joggingDistanceInMeters,
  }) =>
      WorkoutStageCreatorSeriesForm(
        originalStage: originalStage,
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

  test(
    'is submit button disabled, '
    'amount of series is higher than 0, '
    'series distance in meters is higher than 0, '
    'walking distance is higher than 0, '
    'should be false',
    () {
      form = createForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
      );

      expect(form.isSubmitButtonDisabled, false);
    },
  );

  test(
    'is submit button disabled, '
    'amount of series is higher than 0, '
    'series distance in meters is higher than 0, '
    'break jogging distance is higher than 0, '
    'should be false',
    () {
      form = createForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.isSubmitButtonDisabled, false);
    },
  );

  test(
    'is submit button disabled, '
    'amount of series is null, '
    'should be true',
    () {
      form = createForm(
        seriesDistanceInMeters: seriesDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'amount of series is equal to 0, '
    'should be true',
    () {
      form = createForm(
        amountOfSeries: 0,
        seriesDistanceInMeters: seriesDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'amount of series is lower than 0, '
    'should be true',
    () {
      form = createForm(
        amountOfSeries: -10,
        seriesDistanceInMeters: seriesDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'series distance in meters is null, '
    'should be true',
    () {
      form = createForm(
        amountOfSeries: amountOfSeries,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'series distance in meters is equal to 0, '
    'should be true',
    () {
      form = createForm(
        amountOfSeries: 0,
        seriesDistanceInMeters: seriesDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'series distance in meters is lower than 0, '
    'should be true',
    () {
      form = createForm(
        amountOfSeries: -100,
        seriesDistanceInMeters: seriesDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'walking and jogging distances are 0, '
    'should be true',
    () {
      form = createForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: 0,
        joggingDistanceInMeters: 0,
      );

      expect(form.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'walking distance is equal to 0 and jogging distance is higher than 0, '
    'should be false',
    () {
      form = createForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: 0,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.isSubmitButtonDisabled, false);
    },
  );

  test(
    'is submit button disabled, '
    'walking distance is higher than 0 and jogging distance is equal to 0, '
    'should be false',
    () {
      form = createForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: 0,
      );

      expect(form.isSubmitButtonDisabled, false);
    },
  );

  test(
    'is submit button disabled, '
    'walking distance is lower than 0, '
    'should be true',
    () {
      form = createForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: -20,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'jogging distance is lower than 0, '
    'should be true',
    () {
      form = createForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: -80,
      );

      expect(form.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'amount of series is different than original, '
    'should be false',
    () {
      form = createForm(
        originalStage: originalStage,
        amountOfSeries: amountOfSeries + 2,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.isSubmitButtonDisabled, false);
    },
  );

  test(
    'is submit button disabled, '
    'series distance in meters is different than original, '
    'should be false',
    () {
      form = createForm(
        originalStage: originalStage,
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters + 50,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.isSubmitButtonDisabled, false);
    },
  );

  test(
    'is submit button disabled, '
    'walking distance is different than original, '
    'should be false',
    () {
      form = createForm(
        originalStage: originalStage,
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters + 20,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.isSubmitButtonDisabled, false);
    },
  );

  test(
    'is submit button disabled, '
    'jogging distance is different than original, '
    'should be false',
    () {
      form = createForm(
        originalStage: originalStage,
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters + 20,
      );

      expect(form.isSubmitButtonDisabled, false);
    },
  );

  test(
    'is submit button disabled, '
    'all data are same as original, '
    'should be true',
    () {
      form = createForm(
        originalStage: originalStage,
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.isSubmitButtonDisabled, true);
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
    'copy with walking distance in meters',
    () {
      const int expectedWalkingDistanceInMeters = 20;

      form = form.copyWith(
        walkingDistanceInMeters: expectedWalkingDistanceInMeters,
      );
      final form2 = form.copyWith();

      expect(
        form.walkingDistanceInMeters,
        expectedWalkingDistanceInMeters,
      );
      expect(
        form2.walkingDistanceInMeters,
        expectedWalkingDistanceInMeters,
      );
    },
  );

  test(
    'copy with jogging distance in meters',
    () {
      const int expectedJoggingDistanceInMeters = 80;

      form = form.copyWith(
        joggingDistanceInMeters: expectedJoggingDistanceInMeters,
      );
      final form2 = form.copyWith();

      expect(
        form.joggingDistanceInMeters,
        expectedJoggingDistanceInMeters,
      );
      expect(
        form2.joggingDistanceInMeters,
        expectedJoggingDistanceInMeters,
      );
    },
  );
}
