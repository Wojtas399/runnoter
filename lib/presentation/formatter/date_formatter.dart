import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension DateFormatter on DateTime {
  String toUIFormat(BuildContext context) {
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
}
