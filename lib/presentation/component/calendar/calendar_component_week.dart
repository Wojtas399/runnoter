import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../extension/widgets_list_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../activity_item_component.dart';
import '../gap/gap_components.dart';
import '../gap/gap_horizontal_components.dart';
import '../shimmer_container.dart';
import '../text/title_text_components.dart';
import 'bloc/calendar_component_bloc.dart';
import 'calendar_component_health_data.dart';

class CalendarComponentWeek extends StatelessWidget {
  final Function(String workoutId) onWorkoutPressed;
  final Function(String raceId) onRacePressed;
  final Function(DateTime date) onAddWorkout;
  final Function(DateTime date) onAddRace;

  const CalendarComponentWeek({
    super.key,
    required this.onWorkoutPressed,
    required this.onRacePressed,
    required this.onAddWorkout,
    required this.onAddRace,
  });

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
        if (week != null)
          ...week.days.map(
            (day) => _DayItem(
              day: day,
              onWorkoutPressed: onWorkoutPressed,
              onRacePressed: onRacePressed,
              onAddWorkout: () => onAddWorkout(day.date),
              onAddRace: () => onAddRace(day.date),
            ),
          ),
      ].addSeparator(const Divider()),
    );
  }
}

class _DayItem extends StatelessWidget {
  final CalendarDay day;
  final Function(String workoutId) onWorkoutPressed;
  final Function(String raceId) onRacePressed;
  final VoidCallback onAddWorkout;
  final VoidCallback onAddRace;

  const _DayItem({
    required this.day,
    required this.onWorkoutPressed,
    required this.onRacePressed,
    required this.onAddWorkout,
    required this.onAddRace,
  });

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
              _AddActivityButton(
                onAddWorkout: onAddWorkout,
                onAddRace: onAddRace,
              ),
            ],
          ),
          const Gap8(),
          const CalendarComponentHealthData(),
          const Gap8(),
          if (day.workouts.isNotEmpty || day.races.isNotEmpty) ...[
            const Gap16(),
            ...day.workouts.map(
              (workout) => ActivityItem(
                activity: workout,
                onPressed: () => onWorkoutPressed(workout.id),
              ),
            ),
            ...day.races.map(
              (race) => ActivityItem(
                activity: race,
                onPressed: () => onRacePressed(race.id),
              ),
            ),
          ],
        ],
      ),
    );
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

class _AddActivityButton extends StatelessWidget {
  final VoidCallback onAddWorkout;
  final VoidCallback onAddRace;

  const _AddActivityButton({
    required this.onAddWorkout,
    required this.onAddRace,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return PopupMenuButton<_ActivityType>(
      icon: const Icon(Icons.add),
      onSelected: _onSelected,
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _ActivityType.workout,
          child: Row(
            children: [
              const Icon(Icons.directions_run),
              const GapHorizontal8(),
              Text(str.workout),
            ],
          ),
        ),
        PopupMenuItem(
          value: _ActivityType.race,
          child: Row(
            children: [
              const Icon(Icons.emoji_events),
              const GapHorizontal8(),
              Text(str.race),
            ],
          ),
        ),
      ],
    );
  }

  void _onSelected(_ActivityType activityType) {
    switch (activityType) {
      case _ActivityType.workout:
        onAddWorkout();
        break;
      case _ActivityType.race:
        onAddRace();
        break;
    }
  }
}

enum _ActivityType { workout, race }
