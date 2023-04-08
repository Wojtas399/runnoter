import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/presentation/service/date_service.dart';

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
}
