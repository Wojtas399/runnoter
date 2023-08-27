import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/bloc/health_stats/health_stats_bloc.dart';
import 'package:runnoter/domain/cubit/chart_date_range_cubit.dart';

void main() {
  late HealthStatsState state;

  setUp(() {
    state = const HealthStatsState();
  });

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
    'copy with restingHeartRatePoints',
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
    'copy with fastingWeightPoints',
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
