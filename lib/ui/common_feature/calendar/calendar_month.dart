import 'package:flutter/material.dart';

import '../../extension/context_extensions.dart';
import '../../formatter/date_formatter.dart';
import 'calendar_month_days.dart';

class CalendarMonth extends StatelessWidget {
  const CalendarMonth({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _DayLabels(),
        CalendarMonthDays(),
      ],
    );
  }
}

class _DayLabels extends StatelessWidget {
  const _DayLabels();

  @override
  Widget build(BuildContext context) {
    final List<DateTime> daysOfWeek = List<DateTime>.generate(
      7,
      (index) => DateTime(2023, 9, 4 + index),
    );

    return Column(
      children: [
        const Divider(),
        Row(
          children: daysOfWeek
              .map(
                (DateTime date) => _DayLabel(
                  date.toDayAbbreviation(context.languageCode),
                ),
              )
              .toList(),
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
