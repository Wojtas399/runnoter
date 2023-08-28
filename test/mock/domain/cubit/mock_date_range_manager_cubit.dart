import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/cubit/date_range_manager_cubit.dart';

class MockDateRangeManagerCubit extends Mock implements DateRangeManagerCubit {
  void mockStream({required Stream<DateRangeManagerState> expectedStream}) {
    when(() => stream).thenAnswer((_) => expectedStream);
  }
}
