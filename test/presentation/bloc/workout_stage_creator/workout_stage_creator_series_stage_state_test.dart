import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/workout_stage_creator/bloc/workout_stage_creator_series_stage_state.dart';

void main() {
  late WorkoutStageCreatorSeriesStageState state;

  WorkoutStageCreatorSeriesStageState createState({
    BlocStatus status = const BlocStatusInitial(),
    int? amountOfSeries,
    int? seriesDistanceInMeters,
    int? breakWalkingDistanceInMeters,
    int? breakJoggingDistanceInMeters,
  }) =>
      WorkoutStageCreatorSeriesStageState(
        status: status,
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

      state = createState(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakWalkingDistanceInMeters: breakWalkingDistanceInMeters,
      );

      expect(state.areDataCorrect, true);
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

      state = createState(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakJoggingDistanceInMeters: breakJoggingDistanceInMeters,
      );

      expect(state.areDataCorrect, true);
    },
  );

  test(
    'are data correct, '
    'amount of series is null, '
    'should be false',
    () {
      const int seriesDistanceInMeters = 100;
      const int breakJoggingDistanceInMeters = 100;

      state = createState(
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakJoggingDistanceInMeters: breakJoggingDistanceInMeters,
      );

      expect(state.areDataCorrect, false);
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

      state = createState(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakJoggingDistanceInMeters: breakJoggingDistanceInMeters,
      );

      expect(state.areDataCorrect, false);
    },
  );

  test(
    'are data correct, '
    'series distance in meters is null, '
    'should be false',
    () {
      const int amountOfSeries = 10;
      const int breakJoggingDistanceInMeters = 100;

      state = createState(
        amountOfSeries: amountOfSeries,
        breakJoggingDistanceInMeters: breakJoggingDistanceInMeters,
      );

      expect(state.areDataCorrect, false);
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

      state = createState(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakJoggingDistanceInMeters: breakJoggingDistanceInMeters,
      );

      expect(state.areDataCorrect, false);
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

      state = createState(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakWalkingDistanceInMeters: breakWalkingDistanceInMeters,
        breakJoggingDistanceInMeters: breakJoggingDistanceInMeters,
      );

      expect(state.areDataCorrect, false);
    },
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with amount of series',
    () {
      const int expectedAmountOfSeries = 10;

      state = state.copyWith(amountOfSeries: expectedAmountOfSeries);
      final state2 = state.copyWith();

      expect(state.amountOfSeries, expectedAmountOfSeries);
      expect(state2.amountOfSeries, expectedAmountOfSeries);
    },
  );

  test(
    'copy with series distance in meters',
    () {
      const int expectedSeriesDistanceInMeters = 100;

      state = state.copyWith(
        seriesDistanceInMeters: expectedSeriesDistanceInMeters,
      );
      final state2 = state.copyWith();

      expect(state.seriesDistanceInMeters, expectedSeriesDistanceInMeters);
      expect(state2.seriesDistanceInMeters, expectedSeriesDistanceInMeters);
    },
  );

  test(
    'copy with break walking distance in meters',
    () {
      const int expectedBreakWalkingDistanceInMeters = 20;

      state = state.copyWith(
        breakWalkingDistanceInMeters: expectedBreakWalkingDistanceInMeters,
      );
      final state2 = state.copyWith();

      expect(
        state.breakWalkingDistanceInMeters,
        expectedBreakWalkingDistanceInMeters,
      );
      expect(
        state2.breakWalkingDistanceInMeters,
        expectedBreakWalkingDistanceInMeters,
      );
    },
  );

  test(
    'copy with break jogging distance in meters',
    () {
      const int expectedBreakJoggingDistanceInMeters = 80;

      state = state.copyWith(
        breakJoggingDistanceInMeters: expectedBreakJoggingDistanceInMeters,
      );
      final state2 = state.copyWith();

      expect(
        state.breakJoggingDistanceInMeters,
        expectedBreakJoggingDistanceInMeters,
      );
      expect(
        state2.breakJoggingDistanceInMeters,
        expectedBreakJoggingDistanceInMeters,
      );
    },
  );
}
