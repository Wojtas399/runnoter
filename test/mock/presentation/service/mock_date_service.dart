import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';

class MockDateService extends Mock implements DateService {
  void mockGetNow({
    required DateTime now,
  }) {
    when(
      () => getNow(),
    ).thenReturn(now);
  }

  void mockGetDatesFromWeekMatchingToDate({
    required List<DateTime> dates,
  }) {
    when(
      () => getDatesFromWeekMatchingToDate(any()),
    ).thenReturn(dates);
  }
}
