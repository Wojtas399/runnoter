import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/cubit/chart_date_range_cubit.dart';

class MockChartDateRangeCubit extends Mock implements ChartDateRangeCubit {
  void mockStream({required Stream<ChartDateRangeState> expectedStream}) {
    when(() => stream).thenAnswer((_) => expectedStream);
  }
}
