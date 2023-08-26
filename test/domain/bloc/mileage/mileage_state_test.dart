import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/mileage/mileage_bloc.dart';
import 'package:runnoter/domain/cubit/chart_date_range_cubit.dart';

void main() {
  late MileageState state;

  setUp(
    () => state = const MileageState(status: BlocStatusInitial()),
  );

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
      final List<MileageChartPoint> expected = [
        MileageChartPoint(date: DateTime(2023, 8, 21), mileage: 12),
        MileageChartPoint(date: DateTime(2023, 8, 22), mileage: 20),
      ];

      state = state.copyWith(mileageChartPoints: expected);
      final state2 = state.copyWith();

      expect(state.mileageChartPoints, expected);
      expect(state2.mileageChartPoints, expected);
    },
  );
}
