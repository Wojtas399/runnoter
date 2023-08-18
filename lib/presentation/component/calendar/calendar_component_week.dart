import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../extension/widgets_list_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../activity_item_component.dart';
import '../gap/gap_components.dart';
import '../shimmer_container.dart';
import '../text/title_text_components.dart';
import 'bloc/calendar_component_bloc.dart';

class CalendarComponentWeek extends StatelessWidget {
  const CalendarComponentWeek({super.key});

  @override
  Widget build(BuildContext context) {
    final CalendarWeek? week = context.select(
      (CalendarComponentBloc bloc) =>
          bloc.state.weeks?.isNotEmpty == true ? bloc.state.weeks!.first : null,
    );

    return Column(
      children: <Widget>[
        if (week == null)
          for (int i = 0; i < 7; i++) const CurrentWeekDayItemShimmer(),
        if (week != null) ...week.days.map((day) => _DayItem(day: day)),
      ].addSeparator(const Divider(height: 16)),
    );
  }
}

class _DayItem extends StatelessWidget {
  final CalendarDay day;

  const _DayItem({required this.day});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Date(date: day.date, isToday: day.isTodayDay),
              // CurrentWeekAddActivityButton(date: day.date),
            ],
          ),
          const Gap8(),
          Column(
            children: [
              ...day.workouts.map(
                (workout) => ActivityItem(
                  activity: workout,
                  onPressed: () => _onWorkoutPressed(workout.id),
                ),
              ),
              ...day.races.map(
                (race) => ActivityItem(
                  activity: race,
                  onPressed: () => _onRacePressed(race.id),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onWorkoutPressed(String workoutId) {
    //TODO
  }

  void _onRacePressed(String raceId) {
    //TODO
  }
}

class CurrentWeekDayItemShimmer extends StatelessWidget {
  const CurrentWeekDayItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(height: 24, width: 150),
          Gap8(),
          ShimmerContainer(height: 48, width: double.infinity),
        ],
      ),
    );
  }
}

class _Date extends StatelessWidget {
  final DateTime date;
  final bool isToday;

  const _Date({
    required this.date,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isToday
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TitleMedium(
        date.toFullDate(context),
        color: isToday ? Theme.of(context).canvasColor : null,
      ),
    );
  }
}
