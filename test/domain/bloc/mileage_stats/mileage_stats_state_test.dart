import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/bloc/mileage_stats/mileage_stats_bloc.dart';
import 'package:runnoter/domain/cubit/chart_date_range_cubit.dart';

void main() {
  late MileageStatsState state;

  setUp(
    () => state = const MileageStatsState(),
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
        startDate: DateTime(2023, 8, 21),
        endDate: DateTime(2023, 8, 27),
      );

      state = state.copyWith(dateRange: expected);
      final state2 = state.copyWith();

      expect(state.dateRange, expected);
      expect(state2.dateRange, expected);
    },
  );

  test(
    'copy with mileages',
    () {
      final List<MileageStatsChartPoint> expected = [
        MileageStatsChartPoint(date: DateTime(2023, 8, 21), mileage: 12),
        MileageStatsChartPoint(date: DateTime(2023, 8, 22), mileage: 20),
      ];

      state = state.copyWith(mileageChartPoints: expected);
      final state2 = state.copyWith();

      expect(state.mileageChartPoints, expected);
      expect(state2.mileageChartPoints, expected);
    },
  );
}
