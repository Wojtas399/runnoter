import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'calendar_component_month_days.dart';

class CalendarComponentMonth extends StatelessWidget {
  final Function(DateTime date) onMonthDayPressed;

  const CalendarComponentMonth({super.key, required this.onMonthDayPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _DayLabels(),
        CalendarComponentMonthDays(onMonthDayPressed: onMonthDayPressed),
      ],
    );
  }
}

class _DayLabels extends StatelessWidget {
  const _DayLabels();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    final List<String> dayShortLabels = [
      str.mondayShort,
      str.tuesdayShort,
      str.wednesdayShort,
      str.thursdayShort,
      str.fridayShort,
      str.saturdayShort,
      str.sundayShort,
    ];

    return Column(
      children: [
        const Divider(),
        Row(
          children: dayShortLabels.map((label) => _DayLabel(label)).toList(),
        ),
        const Divider(),
      ],
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String label;

  const _DayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
