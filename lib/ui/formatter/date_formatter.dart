import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String toFullDate(String? languageCode) =>
      DateFormat('$_day $_monthName $_year', languageCode).format(this);

  String toTime24() => DateFormat('$_hour24:$_minute').format(this);

  String toTime12() => DateFormat('$_hour12:$_minute').format(this);

  String toDateWithDots() => DateFormat('$_day.$_month.$_year').format(this);

  String toDayWithMonth() => DateFormat('$_day.$_month').format(this);

  String toPathFormat() => DateFormat('$_day-$_month-$_year').format(this);

  String toDayAbbreviation(String? languageCode) =>
      DateFormat(_abbrWeekDay, languageCode).format(this);

  String toMonthAbbreviation(String? languageCode) =>
      DateFormat(_abbrMonth, languageCode).format(this);

  String toMonth(String? languageCode) =>
      DateFormat(_monthName, languageCode).format(this);
}

const String _hour24 = 'HH';
const String _hour12 = 'hh';
const String _minute = 'mm';
const String _day = 'dd';
const String _month = 'MM';
const String _year = DateFormat.YEAR;
const String _monthName = DateFormat.MONTH;
const String _abbrWeekDay = DateFormat.ABBR_WEEKDAY;
const String _abbrMonth = DateFormat.ABBR_MONTH;
