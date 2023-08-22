import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';

class MockDateService extends Mock implements DateService {
  void mockGetToday({
    required DateTime todayDate,
  }) {
    when(
      () => getToday(),
    ).thenReturn(todayDate);
  }

  void mockGetFirstDayOfTheWeek({
    required DateTime date,
  }) {
    when(
      () => getFirstDayOfTheWeek(any()),
    ).thenReturn(date);
  }

  void mockGetLastDayOfTheWeek({
    required DateTime date,
  }) {
    when(
      () => getLastDayOfTheWeek(any()),
    ).thenReturn(date);
  }

  void mockGetFirstDayOfTheMonth({
    required DateTime date,
  }) {
    when(
      () => getFirstDayOfTheMonth(any(), any()),
    ).thenReturn(date);
  }

  void mockGetLastDayOfTheMonth({
    required DateTime date,
  }) {
    when(
      () => getLastDayOfTheMonth(
        any(),
        any(),
      ),
    ).thenReturn(date);
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
}
