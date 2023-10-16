import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/ui/cubit/date_range_manager_cubit.dart';
import 'package:runnoter/ui/cubit/health_stats/health_stats_cubit.dart';

void main() {
  late HealthStatsState state;

  setUp(() {
    state = const HealthStatsState();
  });

  test(
    'copy with dateRangeType, '
    'should copy current value if new value is null',
    () {
      const DateRangeType expected = DateRangeType.month;

      state = state.copyWith(dateRangeType: expected);
      final state2 = state.copyWith();

      expect(state.dateRangeType, expected);
      expect(state2.dateRangeType, expected);
    },
  );

  test(
    'copy with dateRange, '
    'should copy current value if new value is null',
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
    'copy with restingHeartRatePoints, '
    'should copy current value if new value is null',
    () {
      final List<HealthStatsChartPoint> expected = [
        HealthStatsChartPoint(date: DateTime(2023, 1, 10), value: 1),
        HealthStatsChartPoint(date: DateTime(2023, 1, 11), value: 2),
      ];

      state = state.copyWith(restingHeartRatePoints: expected);
      final state2 = state.copyWith();

      expect(state.restingHeartRatePoints, expected);
      expect(state2.restingHeartRatePoints, expected);
    },
  );

  test(
    'copy with fastingWeightPoints, '
    'should copy current value if new value is null',
    () {
      final List<HealthStatsChartPoint> expected = [
        HealthStatsChartPoint(date: DateTime(2023, 1, 10), value: 1),
        HealthStatsChartPoint(date: DateTime(2023, 1, 11), value: 2),
      ];

      state = state.copyWith(fastingWeightPoints: expected);
      final state2 = state.copyWith();

      expect(state.fastingWeightPoints, expected);
      expect(state2.fastingWeightPoints, expected);
    },
  );
}
