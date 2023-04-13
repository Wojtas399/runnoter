import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';

class MockDateService extends Mock implements DateService {
  void mockGetTodayDate({
    required DateTime todayDate,
  }) {
    when(
      () => getTodayDate(),
    ).thenReturn(todayDate);
  }

  void mockGetFirstDateFromWeekMatchingToDate({
    required DateTime date,
  }) {
    when(
      () => getFirstDateFromWeekMatchingToDate(any()),
    ).thenReturn(date);
  }

  void mockGetLastDateFromWeekMatchingToDate({
    required DateTime date,
  }) {
    when(
      () => getLastDateFromWeekMatchingToDate(any()),
    ).thenReturn(date);
  }

  void mockGetDatesFromWeekMatchingToDate({
    required List<DateTime> dates,
  }) {
    when(
      () => getDatesFromWeekMatchingToDate(any()),
    ).thenReturn(dates);
  }

  void mockIsDateFromRange({
    required bool expected,
  }) {
    when(
      () => isDateFromRange(
        date: any(named: 'date'),
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      ),
    ).thenReturn(expected);
  }
}
