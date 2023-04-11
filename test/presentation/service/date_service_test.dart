import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/common/date_service.dart';

void main() {
  final DateService service = DateService();

  test(
    'get dates from week matching to date, '
    'should return all dates from week which includes given date',
    () {
      final DateTime date = DateTime(2023, 4, 6);
      final List<DateTime> expectedDates = [];
      for (int i = 3; i <= 9; i++) {
        expectedDates.add(
          DateTime(2023, 4, i),
        );
      }

      final List<DateTime> dates = service.getDatesFromWeekMatchingToDate(date);

      expect(dates, expectedDates);
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
      final DateTime date = DateTime(2023, 4, 3, 12, 30);
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
}
