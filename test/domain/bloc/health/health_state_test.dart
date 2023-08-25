import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/health/health_bloc.dart';
import 'package:runnoter/domain/cubit/chart_date_range_cubit.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';

void main() {
  late HealthState state;

  HealthState createState() => const HealthState(status: BlocStatusInitial());

  setUp(() {
    state = createState();
  });

  test(
    'copy with status',
    () {
      const BlocStatus expected = BlocStatusLoading();

      state = state.copyWith(status: expected);
      final state2 = state.copyWith();

      expect(state.status, expected);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with todayMeasurement',
    () {
      final HealthMeasurement expected = HealthMeasurement(
        userId: 'u1',
        date: DateTime(2023, 1, 10),
        restingHeartRate: 50,
        fastingWeight: 80.2,
      );

      state = state.copyWith(todayMeasurement: expected);
      final state2 = state.copyWith();

      expect(state.todayMeasurement, expected);
      expect(state2.todayMeasurement, expected);
    },
  );

  test(
    'copy with dateRangeType',
    () {
      const DateRangeType expected = DateRangeType.month;

      state = state.copyWith(dateRangeType: expected);
      final state2 = state.copyWith();

      expect(state.dateRangeType, expected);
      expect(state2.dateRangeType, expected);
    },
  );

  test(
    'copy with dateRange',
    () {
      final DateRange expected = DateRange(
        startDate: DateTime(2023, 1),
        endDate: DateTime(2023, 1, 31),
      );

      state = state.copyWith(dateRange: expected);
      final state2 = state.copyWith();

      expect(state.dateRange, expected);
      expect(state2.dateRange, expected);
    },
  );

  test(
    'copy with removedTodayMeasurement',
    () {
      final HealthMeasurement expected = HealthMeasurement(
        userId: 'u1',
        date: DateTime(2023, 1, 10),
        restingHeartRate: 50,
        fastingWeight: 80.2,
      );

      state = state.copyWith(todayMeasurement: expected);
      final state2 = state.copyWith(removedTodayMeasurement: true);

      expect(state.todayMeasurement, expected);
      expect(state2.todayMeasurement, null);
    },
  );

  test(
    'copy with restingHeartRatePoints',
    () {
      final List<HealthChartPoint> expected = [
        HealthChartPoint(date: DateTime(2023, 1, 10), value: 1),
        HealthChartPoint(date: DateTime(2023, 1, 11), value: 2),
      ];

      state = state.copyWith(restingHeartRatePoints: expected);
      final state2 = state.copyWith();

      expect(state.restingHeartRatePoints, expected);
      expect(state2.restingHeartRatePoints, expected);
    },
  );

  test(
    'copy with fastingWeightPoints',
    () {
      final List<HealthChartPoint> expected = [
        HealthChartPoint(date: DateTime(2023, 1, 10), value: 1),
        HealthChartPoint(date: DateTime(2023, 1, 11), value: 2),
      ];

      state = state.copyWith(fastingWeightPoints: expected);
      final state2 = state.copyWith();

      expect(state.fastingWeightPoints, expected);
      expect(state2.fastingWeightPoints, expected);
    },
  );
}
