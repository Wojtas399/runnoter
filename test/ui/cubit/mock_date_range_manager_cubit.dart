import 'package:mocktail/mocktail.dart';
import 'package:runnoter/ui/cubit/date_range_manager_cubit.dart';

class MockDateRangeManagerCubit extends Mock implements DateRangeManagerCubit {
  void mockStream({
    DateRangeManagerState? expectedStreamValue,
    Stream<DateRangeManagerState>? expectedStream,
  }) {
    when(() => stream).thenAnswer(
      (_) =>
          expectedStream ??
          Stream.value(
            expectedStreamValue ??
                const DateRangeManagerState(dateRangeType: DateRangeType.week),
          ),
    );
  }
}
