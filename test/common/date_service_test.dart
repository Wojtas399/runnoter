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
    'should return first day of given month',
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
    'should return last day of given month',
    () {
      const int month = 4;
      const int year = 2023;
      final DateTime expectedDay = DateTime(2023, 4, 30);

      final DateTime lastDayOfMonth = service.getLastDayOfTheMonth(month, year);

      expect(lastDayOfMonth, expectedDay);
    },
  );

  test(
    'get first day of the year, '
    'should return first day of given year',
    () {
      const int year = 2023;
      final DateTime expectedDay = DateTime(2023, 1, 1);

      final DateTime firstDayOfTheYear = service.getFirstDayOfTheYear(year);

      expect(firstDayOfTheYear, expectedDay);
    },
  );

  test(
    'get last day of the year, '
    'should return last day of given year',
    () {
      const int year = 2023;
      final DateTime expectedDay = DateTime(2023, 12, 31);

      final DateTime lastDayOfTheYear = service.getLastDayOfTheYear(year);

      expect(lastDayOfTheYear, expectedDay);
    },
  );

  test(
    'is date from range, '
    'date is from range, '
    'should return true',
    () {
      final DateTime date = DateTime(2023, 4, 22);
      final DateTime startDate = DateTime(2023, 2, 6);
      final DateTime endDate = DateTime(2023, 5, 9);

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
    'is today, '
    'year, month and day are the same as in today date, '
    'should be true',
    () {
      final DateTime date = DateTime.now();

      final bool result = service.isToday(date);

      expect(result, true);
    },
  );

  test(
    'is today, '
    'month is different than the month of today date, '
    'should be false',
    () {
      final DateTime today = DateTime.now();
      final DateTime date = DateTime(today.year, today.month + 1, today.day);

      final bool result = service.isToday(date);

      expect(result, false);
    },
  );

  test(
    'is today, '
    'day is different than the day of today date, '
    'should be false',
    () {
      final DateTime today = DateTime.now();
      final DateTime date = DateTime(today.year, today.month, today.day + 1);

      final bool result = service.isToday(date);

      expect(result, false);
    },
  );

  test(
    'is today, '
    'year is different than the year of today date, '
    'should be false',
    () {
      final DateTime today = DateTime.now();
      final DateTime date = DateTime(today.year + 1, today.month, today.day);

      final bool result = service.isToday(date);

      expect(result, false);
    },
  );

  test(
    'are days the same, '
    'year, month and day are the same, '
    'should be true',
    () {
      final DateTime date1 = DateTime(2023, 2, 2, 10, 30);
      final DateTime date2 = DateTime(2023, 2, 2, 11, 25);

      final bool result = service.areDaysTheSame(date1, date2);

      expect(result, true);
    },
  );

  test(
    'are days the same, '
    'years are different, '
    'should be false',
    () {
      final DateTime date1 = DateTime(2022, 2, 2, 10, 30);
      final DateTime date2 = DateTime(2023, 2, 2, 11, 25);

      final bool result = service.areDaysTheSame(date1, date2);

      expect(result, false);
    },
  );

  test(
    'are days the same, '
    'months are different, '
    'should be false',
    () {
      final DateTime date1 = DateTime(2023, 4, 2, 10, 30);
      final DateTime date2 = DateTime(2023, 2, 2, 11, 25);

      final bool result = service.areDaysTheSame(date1, date2);

      expect(result, false);
    },
  );

  test(
    'are days the same, '
    'days are different, '
    'should be false',
    () {
      final DateTime date1 = DateTime(2023, 2, 20, 10, 30);
      final DateTime date2 = DateTime(2023, 2, 2, 11, 25);

      final bool result = service.areDaysTheSame(date1, date2);

      expect(result, false);
    },
  );
}
