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

  void mockGetFirstDateOfTheMonth({
    required DateTime date,
  }) {
    when(
      () => getFirstDateOfTheMonth(any(), any()),
    ).thenReturn(date);
  }

  void mockGetLastDateOfTheMonth({
    required DateTime date,
  }) {
    when(
      () => getLastDateOfTheMonth(
        any(),
        any(),
      ),
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

  void mockAreDatesTheSame({
    required bool expected,
  }) {
    when(
      () => areDatesTheSame(
        any(),
        any(),
      ),
    ).thenReturn(expected);
  }

  void mockIsDate1BeforeDate2({
    required bool expected,
  }) {
    when(
      () => isDate1BeforeDate2(
        any(),
        any(),
      ),
    ).thenReturn(expected);
  }
}
