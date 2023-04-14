import '../utils/utils.dart';

DateTime mapDateTimeFromString(String date) {
  final List<String> splittedDate = date.split('-');
  final int year = int.parse(splittedDate[2]);
  final int month = int.parse(splittedDate[1]);
  final int day = int.parse(splittedDate[0]);
  return DateTime(year, month, day);
}

String mapDateTimeToString(DateTime date) {
  final String year = '${date.year}';
  final String month = twoDigits(date.month);
  final String day = twoDigits(date.day);
  return '$day-$month-$year';
}
