import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/model/workout.dart';
import 'package:runnoter/ui/cubit/workout_stage_creator/workout_stage_creator_cubit.dart';

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

  test(
    'canSubmit, '
    'amount of series is higher than 0, '
    'series distance in meters is higher than 0, '
    'walking distance is higher than 0, '
    'should be true',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
      );

      expect(form.canSubmit, true);
    },
  );

  test(
    'canSubmit, '
    'amount of series is higher than 0, '
    'series distance in meters is higher than 0, '
    'break jogging distance is higher than 0, '
    'should be true',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.canSubmit, true);
    },
  );

  test(
    'canSubmit, '
    'amount of series is null, '
    'should be false',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        seriesDistanceInMeters: seriesDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'canSubmit, '
    'amount of series is equal to 0, '
    'should be false',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        amountOfSeries: 0,
        seriesDistanceInMeters: seriesDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'canSubmit, '
    'amount of series is lower than 0, '
    'should be false',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        amountOfSeries: -10,
        seriesDistanceInMeters: seriesDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'canSubmit, '
    'series distance in meters is null, '
    'should be false',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        amountOfSeries: amountOfSeries,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'canSubmit, '
    'series distance in meters is equal to 0, '
    'should be false',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        amountOfSeries: 0,
        seriesDistanceInMeters: seriesDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'canSubmit, '
    'series distance in meters is lower than 0, '
    'should be false',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        amountOfSeries: -100,
        seriesDistanceInMeters: seriesDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'canSubmit, '
    'walking and jogging distances are 0, '
    'should be false',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: 0,
        joggingDistanceInMeters: 0,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'canSubmit, '
    'walking distance is equal to 0 and jogging distance is higher than 0, '
    'should be true',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: 0,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.canSubmit, true);
    },
  );

  test(
    'canSubmit, '
    'walking distance is higher than 0 and jogging distance is equal to 0, '
    'should be true',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: 0,
      );

      expect(form.canSubmit, true);
    },
  );

  test(
    'canSubmit, '
    'walking distance is lower than 0, '
    'should be false',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: -20,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'canSubmit, '
    'jogging distance is lower than 0, '
    'should be false',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: -80,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'canSubmit, '
    'amount of series is different than original, '
    'should be true',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        originalStage: originalStage,
        amountOfSeries: amountOfSeries + 2,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.canSubmit, true);
    },
  );

  test(
    'canSubmit, '
    'series distance in meters is different than original, '
    'should be true',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        originalStage: originalStage,
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters + 50,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.canSubmit, true);
    },
  );

  test(
    'canSubmit, '
    'walking distance is different than original, '
    'should be true',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        originalStage: originalStage,
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters + 20,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.canSubmit, true);
    },
  );

  test(
    'canSubmit, '
    'jogging distance is different than original, '
    'should be true',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        originalStage: originalStage,
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters + 20,
      );

      expect(form.canSubmit, true);
    },
  );

  test(
    'canSubmit, '
    'all data are same as original, '
    'should be false',
    () {
      form = const WorkoutStageCreatorSeriesForm(
        originalStage: originalStage,
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

      expect(form.canSubmit, false);
    },
  );

  test(
    'copy with amountOfSeries, '
    'should copy current value if new value is null',
    () {
      const int expected = 10;

      form = form.copyWith(amountOfSeries: expected);
      final form2 = form.copyWith();

      expect(form.amountOfSeries, expected);
      expect(form2.amountOfSeries, expected);
    },
  );

  test(
    'copy with seriesDistanceInMeters, '
    'should copy current value if new value is null',
    () {
      const int expected = 100;

      form = form.copyWith(
        seriesDistanceInMeters: expected,
      );
      final form2 = form.copyWith();

      expect(form.seriesDistanceInMeters, expected);
      expect(form2.seriesDistanceInMeters, expected);
    },
  );

  test(
    'copy with walkingDistanceInMeters, '
    'should copy current value if new value is null',
    () {
      const int expected = 20;

      form = form.copyWith(walkingDistanceInMeters: expected);
      final form2 = form.copyWith();

      expect(form.walkingDistanceInMeters, expected);
      expect(form2.walkingDistanceInMeters, expected);
    },
  );

  test(
    'copy with joggingDistanceInMeters, '
    'should copy current value if new value is null',
    () {
      const int expected = 80;

      form = form.copyWith(joggingDistanceInMeters: expected);
      final form2 = form.copyWith();

      expect(form.joggingDistanceInMeters, expected);
      expect(form2.joggingDistanceInMeters, expected);
    },
  );
}
