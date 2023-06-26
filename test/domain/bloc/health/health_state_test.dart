import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/health/health_bloc.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';
import 'package:runnoter/domain/service/health_chart_service.dart';

void main() {
  late HealthState state;

  HealthState createState() => const HealthState(
        status: BlocStatusInitial(),
        chartRange: ChartRange.month,
      );

  setUp(() {
    state = createState();
  });

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
    'copy with today measurement',
    () {
      final HealthMeasurement expectedMeasurement = HealthMeasurement(
        userId: 'u1',
        date: DateTime(2023, 1, 10),
        restingHeartRate: 50,
        fastingWeight: 80.2,
      );

      state = state.copyWith(todayMeasurement: expectedMeasurement);
      final state2 = state.copyWith();

      expect(state.todayMeasurement, expectedMeasurement);
      expect(state2.todayMeasurement, expectedMeasurement);
    },
  );

  test(
    'copy with removed today measurement',
    () {
      final HealthMeasurement expectedMeasurement = HealthMeasurement(
        userId: 'u1',
        date: DateTime(2023, 1, 10),
        restingHeartRate: 50,
        fastingWeight: 80.2,
      );

      state = state.copyWith(todayMeasurement: expectedMeasurement);
      final state2 = state.copyWith(removedTodayMeasurement: true);

      expect(state.todayMeasurement, expectedMeasurement);
      expect(state2.todayMeasurement, null);
    },
  );

  test(
    'copy with chart range',
    () {
      const ChartRange expectedChartRange = ChartRange.month;

      state = state.copyWith(chartRange: expectedChartRange);
      final state2 = state.copyWith();

      expect(state.chartRange, expectedChartRange);
      expect(state2.chartRange, expectedChartRange);
    },
  );

  test(
    'copy with chart start date',
    () {
      final DateTime expectedDate = DateTime(2023, 1, 10);

      state = state.copyWith(chartStartDate: expectedDate);
      final state2 = state.copyWith();

      expect(state.chartStartDate, expectedDate);
      expect(state2.chartStartDate, expectedDate);
    },
  );

  test(
    'copy with chart end date',
    () {
      final DateTime expectedDate = DateTime(2023, 1, 10);

      state = state.copyWith(chartEndDate: expectedDate);
      final state2 = state.copyWith();

      expect(state.chartEndDate, expectedDate);
      expect(state2.chartEndDate, expectedDate);
    },
  );

  test(
    'copy with chart resting heart rate points',
    () {
      final List<HealthChartPoint> expectedPoints = [
        HealthChartPoint(date: DateTime(2023, 1, 10), value: 1),
        HealthChartPoint(date: DateTime(2023, 1, 11), value: 2),
      ];

      state = state.copyWith(restingHeartRatePoints: expectedPoints);
      final state2 = state.copyWith();

      expect(state.restingHeartRatePoints, expectedPoints);
      expect(state2.restingHeartRatePoints, expectedPoints);
    },
  );

  test(
    'copy with chart fasting weight points',
    () {
      final List<HealthChartPoint> expectedPoints = [
        HealthChartPoint(date: DateTime(2023, 1, 10), value: 1),
        HealthChartPoint(date: DateTime(2023, 1, 11), value: 2),
      ];

      state = state.copyWith(fastingWeightPoints: expectedPoints);
      final state2 = state.copyWith();

      expect(state.fastingWeightPoints, expectedPoints);
      expect(state2.fastingWeightPoints, expectedPoints);
    },
  );
}
