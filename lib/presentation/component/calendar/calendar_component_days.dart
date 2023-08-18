import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../text/body_text_components.dart';
import 'bloc/calendar_component_bloc.dart';

class CalendarComponentDays extends StatelessWidget {
  const CalendarComponentDays({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CalendarWeek>? weeks = context.select(
      (CalendarComponentBloc bloc) => bloc.state.weeks,
    );

    return weeks == null
        ? const SizedBox()
        : Table(
            border: TableBorder.all(
              width: 0.4,
              color: Theme.of(context).colorScheme.outline,
            ),
            children: weeks
                .map(
                  (CalendarWeek week) => TableRow(
                    children: week.days
                        .map(
                          (CalendarDay day) => TableCell(
                            child: _DayItem(day: day),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          );
  }
}

class _DayItem extends StatelessWidget {
  final CalendarDay day;

  const _DayItem({
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: day.isDisabled ? 0.3 : 1,
      child: Material(
        color: day.isDisabled
            ? Theme.of(context).colorScheme.outline.withOpacity(0.20)
            : null,
        child: InkWell(
          onTap: day.isDisabled ? null : () => _onPressed(context),
          child: SizedBox(
            width: double.infinity,
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DayNumber(
                  number: day.date.day,
                  isMarkedAsToday: day.isTodayDay,
                ),
                _Activities(activities: day.activities),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<CalendarComponentBloc>().add(
          CalendarComponentEventOnDayPressed(date: day.date),
        );
  }
}

class _DayNumber extends StatelessWidget {
  final int number;
  final bool isMarkedAsToday;

  const _DayNumber({
    required this.number,
    required this.isMarkedAsToday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isMarkedAsToday ? Theme.of(context).colorScheme.primary : null,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(4),
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: BodySmall(
        '$number',
        color: isMarkedAsToday ? Theme.of(context).canvasColor : null,
      ),
    );
  }
}

class _Activities extends StatelessWidget {
  final List<CalendarDayActivity> activities;

  const _Activities({
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    List<CalendarDayActivity> maxThreeActivitiesToDisplay = activities.sublist(
      0,
      activities.length > 3
          ? 2
          : activities.length == 3
              ? 3
              : activities.length,
    );

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ...maxThreeActivitiesToDisplay
                .map(
                  (activity) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Container(
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        color: activity.color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                )
                .toList(),
            if (activities.length > 3) BodySmall('+${activities.length - 2}'),
          ],
        ),
      ),
    );
  }
}
