import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension DateFormatter on DateTime {
  String toFullDate(BuildContext context) {
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

    return '$day ${months[month - 1].toLowerCase()} $year';
  }

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
}
