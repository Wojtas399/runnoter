import 'package:firebase/mapper/date_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map datetime from string, '
    'should map date from string format to DateTime type',
    () {
      const String dateStr = '10-04-2023';
      final DateTime expectedDateTime = DateTime(2023, 4, 10);

      final DateTime dateTime = mapDateTimeFromString(dateStr);

      expect(dateTime, expectedDateTime);
    },
  );

  test(
    'map datetime to string, '
    'should map date from DateTime type to string',
    () {
      final DateTime dateTime = DateTime(2023, 4, 10);
      const String expectedDateStr = '10-04-2023';

      final String dateStr = mapDateTimeToString(dateTime);

      expect(dateStr, expectedDateStr);
    },
  );
}
