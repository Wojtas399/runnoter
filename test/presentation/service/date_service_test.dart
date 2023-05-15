import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/common/date_service.dart';

void main() {
  final DateService service = DateService();

  test(
    'get first day of the week, '
    'should return first day of the week which includes given day',
    () {
      final DateTime day = DateTime(2023, 4, 6);
      final DateTime expectedDay = DateTime(2023, 4, 3);

      final DateTime firstDayOfTheWeek = service.getFirstDayOfTheWeek(day);

      expect(firstDayOfTheWeek, expectedDay);
    },
  );

  test(
    'get last day of the week, '
    'should return last day of the week which includes given day',
    () {
      final DateTime day = DateTime(2023, 4, 6);
      final DateTime expectedDay = DateTime(2023, 4, 9);

      final DateTime lastDayOfTheWeek = service.getLastDayOfTheWeek(day);

      expect(lastDayOfTheWeek, expectedDay);
    },
  );

  test(
    'get first day of the month, '
    'should return first day of the month which includes given day',
    () {
      const int month = 4;
      const int year = 2023;
      final DateTime expectedDay = DateTime(2023, 4, 1);

      final DateTime firstDayOfMonth =
          service.getFirstDayOfTheMonth(month, year);

      expect(firstDayOfMonth, expectedDay);
    },
  );

  test(
    'get last day of the month, '
    'should return last day of the month which includes given date',
    () {
      const int month = 4;
      const int year = 2023;
      final DateTime expectedDay = DateTime(2023, 4, 30);

      final DateTime lastDayOfMonth = service.getLastDayOfTheMonth(month, year);

      expect(lastDayOfMonth, expectedDay);
    },
  );

  test(
    'get days from week, '
    'should return all days from week which includes given day',
    () {
      final DateTime day = DateTime(2023, 4, 6);
      final List<DateTime> expectedDays = [];
      for (int i = 3; i <= 9; i++) {
        expectedDays.add(
          DateTime(2023, 4, i),
        );
      }

      final List<DateTime> days = service.getDaysFromWeek(day);

      expect(days, expectedDays);
    },
  );

  test(
    'is date from range, '
    'date is from range, '
    'should return true',
    () {
      final DateTime date = DateTime(2023, 4, 6, 12, 30);
      final DateTime startDate = DateTime(2023, 4, 3, 19, 00);
      final DateTime endDate = DateTime(2023, 4, 9, 10, 15);

      final bool result = service.isDateFromRange(
        date: date,
        startDate: startDate,
        endDate: endDate,
      );

      expect(result, true);
    },
  );

  test(
    'is date from range, '
    'date is equal to start date, '
    'should return true',
    () {
      final DateTime date = DateTime(2023, 4, 3);
      final DateTime startDate = DateTime(2023, 4, 3, 19, 00);
      final DateTime endDate = DateTime(2023, 4, 9, 10, 15);

      final bool result = service.isDateFromRange(
        date: date,
        startDate: startDate,
        endDate: endDate,
      );

      expect(result, true);
    },
  );

  test(
    'is date from range, '
    'date is equal to end date, '
    'should return true',
    () {
      final DateTime date = DateTime(2023, 4, 9, 12, 30);
      final DateTime startDate = DateTime(2023, 4, 3, 19, 00);
      final DateTime endDate = DateTime(2023, 4, 9, 10, 15);

      final bool result = service.isDateFromRange(
        date: date,
        startDate: startDate,
        endDate: endDate,
      );

      expect(result, true);
    },
  );

  test(
    'is date from range, '
    'date is out of range, '
    'should return false',
    () {
      final DateTime date = DateTime(2023, 4, 10);
      final DateTime startDate = DateTime(2023, 4, 3, 19, 00);
      final DateTime endDate = DateTime(2023, 4, 9, 10, 15);

      final bool result = service.isDateFromRange(
        date: date,
        startDate: startDate,
        endDate: endDate,
      );

      expect(result, false);
    },
  );

  test(
    'are dates the same, '
    'year, month and day are the same, '
    'should be true',
    () {
      final DateTime date1 = DateTime(2023, 2, 2, 10, 30);
      final DateTime date2 = DateTime(2023, 2, 2, 11, 25);

      final bool result = service.areDatesTheSame(date1, date2);

      expect(result, true);
    },
  );

  test(
    'are dates the same, '
    'years are different, '
    'should be false',
    () {
      final DateTime date1 = DateTime(2022, 2, 2, 10, 30);
      final DateTime date2 = DateTime(2023, 2, 2, 11, 25);

      final bool result = service.areDatesTheSame(date1, date2);

      expect(result, false);
    },
  );

  test(
    'are dates the same, '
    'months are different, '
    'should be false',
    () {
      final DateTime date1 = DateTime(2023, 4, 2, 10, 30);
      final DateTime date2 = DateTime(2023, 2, 2, 11, 25);

      final bool result = service.areDatesTheSame(date1, date2);

      expect(result, false);
    },
  );

  test(
    'are dates the same, '
    'days are different, '
    'should be false',
    () {
      final DateTime date1 = DateTime(2023, 2, 20, 10, 30);
      final DateTime date2 = DateTime(2023, 2, 2, 11, 25);

      final bool result = service.areDatesTheSame(date1, date2);

      expect(result, false);
    },
  );

  test(
    'is date1 before date2, '
    'date1 is before date2, '
    'should return true',
    () {
      final DateTime date1 = DateTime(2023, 2, 1);
      final DateTime date2 = DateTime(2023, 2, 10);

      final bool result = service.isDate1BeforeDate2(date1, date2);

      expect(result, true);
    },
  );

  test(
    'is date1 before date2, '
    'date1 is equal to date2, '
    'should return false',
    () {
      final DateTime date1 = DateTime(2023, 2, 10, 12, 30);
      final DateTime date2 = DateTime(2023, 2, 10, 10, 30);

      final bool result = service.isDate1BeforeDate2(date1, date2);

      expect(result, false);
    },
  );

  test(
    'is date1 before date2, '
    'date1 is after date2, '
    'should return false',
    () {
      final DateTime date1 = DateTime(2023, 2, 15);
      final DateTime date2 = DateTime(2023, 2, 10);

      final bool result = service.isDate1BeforeDate2(date1, date2);

      expect(result, false);
    },
  );
}
