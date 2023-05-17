import 'package:firebase/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension DateFormatter on DateTime {
  String toMonthName(BuildContext context) {
    final str = Str.of(context);
    final List<String> months = [
      str.january,
      str.february,
      str.march,
      str.april,
      str.may,
      str.june,
      str.july,
      str.august,
      str.september,
      str.october,
      str.november,
      str.december,
    ];
    return months[month - 1];
  }

  String toFullDate(BuildContext context) =>
      '$day ${toMonthName(context).toLowerCase()} $year';

  String toDateWithDots() => '${twoDigits(day)}.${twoDigits(month)}.$year';

  String toDayAbbreviation(BuildContext context) {
    final str = Str.of(context);
    final List<String> dayNameAbbreviations = [
      str.mondayShort,
      str.tuesdayShort,
      str.wednesdayShort,
      str.thursdayShort,
      str.fridayShort,
      str.saturdayShort,
      str.sundayShort,
    ];
    return dayNameAbbreviations[weekday - 1];
  }

  String toMonthAbbreviation(BuildContext context) {
    final str = Str.of(context);
    final List<String> monthAbbreviations = [
      str.januaryShort,
      str.februaryShort,
      str.marchShort,
      str.aprilShort,
      str.mayShort,
      str.juneShort,
      str.julyShort,
      str.augustShort,
      str.septemberShort,
      str.octoberShort,
      str.novemberShort,
      str.decemberShort,
    ];
    return monthAbbreviations[month - 1];
  }
}
