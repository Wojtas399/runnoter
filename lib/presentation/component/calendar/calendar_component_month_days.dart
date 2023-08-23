import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/calendar_week_day.dart';
import '../../../domain/entity/race.dart';
import '../../../domain/entity/workout.dart';
import '../../formatter/activity_status_formatter.dart';
import '../text/body_text_components.dart';
import 'bloc/calendar_component_bloc.dart';

class CalendarComponentMonthDays extends StatelessWidget {
  const CalendarComponentMonthDays({super.key});

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
            children: [
              ...weeks.map(
                (CalendarWeek week) => TableRow(
                  children: [
                    ...week.days.map(
                      (CalendarWeekDay day) => TableCell(
                        child: _DayItem(day),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}

class _DayItem extends StatelessWidget {
  final CalendarWeekDay day;

  const _DayItem(this.day);

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
                _Activities(workouts: day.workouts, races: day.races),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<CalendarComponentBloc>().add(
          CalendarComponentEventDayPressed(date: day.date),
        );
  }
}

class _DayNumber extends StatelessWidget {
  final int number;
  final bool isMarkedAsToday;

  const _DayNumber({required this.number, required this.isMarkedAsToday});

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
  final List<Workout> workouts;
  final List<Race> races;

  const _Activities({required this.workouts, required this.races});

  @override
  Widget build(BuildContext context) {
    final int maxNumberOfWorkoutsToDisplay = races.isEmpty ? 3 : 2;
    final List<Workout> workoutsToDisplay = workouts.sublist(
      0,
      workouts.length > maxNumberOfWorkoutsToDisplay
          ? maxNumberOfWorkoutsToDisplay - 1
          : workouts.length,
    );
    final int numberOfActivities = workouts.length + races.length;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (races.isNotEmpty)
              _ActivityItem(
                color: Theme.of(context).colorScheme.primary,
              ),
            ...workoutsToDisplay.map(
              (workout) => _ActivityItem(
                color: workout.status.toColor(context),
              ),
            ),
            if (numberOfActivities > 3) BodySmall('+${numberOfActivities - 2}'),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final Color color;

  const _ActivityItem({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        width: double.infinity,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
