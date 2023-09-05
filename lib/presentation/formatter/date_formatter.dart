import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String toFullDate(String? languageCode) =>
      DateFormat('dd MMMM yyyy', languageCode).format(this);

  String toDateWithDots() => DateFormat('dd.MM.yyyy').format(this);

  String toDayWithMonth() => DateFormat('dd.MM').format(this);

  String toPathFormat() => DateFormat('dd-MM-yyyy').format(this);

  String toDayAbbreviation(String? languageCode) =>
      DateFormat(DateFormat.ABBR_WEEKDAY, languageCode).format(this);

  String toMonthAbbreviation(String? languageCode) =>
      DateFormat(DateFormat.ABBR_MONTH, languageCode).format(this);

  String toMonth(String? languageCode) =>
      DateFormat(DateFormat.MONTH, languageCode).format(this);
}
