import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/additional_model/calendar_week_day.dart';
import '../../domain/entity/health_measurement.dart';
import '../../domain/entity/race.dart';
import '../../domain/entity/workout.dart';
import '../formatter/date_formatter.dart';
import 'activity_item_component.dart';
import 'gap/gap_components.dart';
import 'gap/gap_horizontal_components.dart';
import 'nullable_text_component.dart';
import 'text/body_text_components.dart';
import 'text/label_text_components.dart';
import 'text/title_text_components.dart';

class WeekDayItem extends StatelessWidget {
  final CalendarWeekDay day;
  final Function(String workoutId)? onWorkoutPressed;
  final Function(String raceId)? onRacePressed;
  final VoidCallback? onEditHealthMeasurement;
  final VoidCallback? onAddWorkout;
  final VoidCallback? onAddRace;

  const WeekDayItem({
    super.key,
    required this.day,
    this.onWorkoutPressed,
    this.onRacePressed,
    this.onEditHealthMeasurement,
    this.onAddWorkout,
    this.onAddRace,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(
            date: day.date,
            isToday: day.isTodayDay,
            onEditHealthMeasurement: onEditHealthMeasurement,
            onAddWorkout: onAddWorkout,
            onAddRace: onAddRace,
          ),
          const Gap8(),
          _HealthData(healthMeasurement: day.healthMeasurement),
          const Gap8(),
          _Activities(
            workouts: day.workouts,
            races: day.races,
            onWorkoutPressed: _onWorkoutPressed,
            onRacePressed: _onRacePressed,
          ),
        ],
      ),
    );
  }

  void _onWorkoutPressed(String workoutId) {
    if (onWorkoutPressed != null) onWorkoutPressed!(workoutId);
  }

  void _onRacePressed(String raceId) {
    if (onRacePressed != null) onRacePressed!(raceId);
  }
}

class _Header extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final VoidCallback? onEditHealthMeasurement;
  final VoidCallback? onAddWorkout;
  final VoidCallback? onAddRace;

  const _Header({
    required this.date,
    required this.isToday,
    this.onEditHealthMeasurement,
    this.onAddWorkout,
    this.onAddRace,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _Date(date: date, isToday: isToday),
        if (onEditHealthMeasurement != null ||
            onAddWorkout != null ||
            onAddRace != null)
          _MoreButton(
            onEditHealthMeasurement: onEditHealthMeasurement,
            onAddWorkout: onAddWorkout,
            onAddRace: onAddRace,
          ),
      ],
    );
  }
}

class _HealthData extends StatelessWidget {
  final HealthMeasurement? healthMeasurement;

  const _HealthData({this.healthMeasurement});

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _ValueWithLabel(
              label: str.healthRestingHeartRate,
              value: healthMeasurement != null
                  ? '${healthMeasurement!.restingHeartRate} ${str.heartRateUnit}'
                  : null,
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: _ValueWithLabel(
              label: Str.of(context).healthFastingWeight,
              value: healthMeasurement != null
                  ? '${healthMeasurement!.fastingWeight} kg'
                  : null,
            ),
          )
        ],
      ),
    );
  }
}

class _Activities extends StatelessWidget {
  final List<Workout> workouts;
  final List<Race> races;
  final Function(String workoutId) onWorkoutPressed;
  final Function(String raceId) onRacePressed;

  const _Activities({
    required this.workouts,
    required this.races,
    required this.onWorkoutPressed,
    required this.onRacePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (workouts.isNotEmpty || races.isNotEmpty) ...[
          const Gap16(),
          ...races.map(
            (race) => ActivityItem(
              activity: race,
              onPressed: () => onRacePressed(race.id),
            ),
          ),
          ...workouts.map(
            (workout) => ActivityItem(
              activity: workout,
              onPressed: () => onWorkoutPressed(workout.id),
            ),
          ),
        ],
        if (workouts.isEmpty && races.isEmpty) ...[
          const Gap16(),
          Center(
            child: BodyLarge(
              Str.of(context).dayPreviewNoActivitiesTitle,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const Gap16(),
        ]
      ],
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

class _MoreButton extends StatelessWidget {
  final VoidCallback? onEditHealthMeasurement;
  final VoidCallback? onAddWorkout;
  final VoidCallback? onAddRace;

  const _MoreButton({
    this.onEditHealthMeasurement,
    this.onAddWorkout,
    this.onAddRace,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return PopupMenuButton<_MoreButtonAction>(
      icon: const Icon(Icons.more_horiz),
      onSelected: _onSelected,
      itemBuilder: (_) => [
        if (onEditHealthMeasurement != null)
          PopupMenuItem(
            value: _MoreButtonAction.editHealthMeasurement,
            child: Row(
              children: [
                const Icon(Icons.health_and_safety),
                const GapHorizontal8(),
                Text(str.editHealthMeasurement),
              ],
            ),
          ),
        if (onAddWorkout != null)
          PopupMenuItem(
            value: _MoreButtonAction.addWorkout,
            child: Row(
              children: [
                const Icon(Icons.directions_run),
                const GapHorizontal8(),
                Text(str.addWorkout),
              ],
            ),
          ),
        if (onAddRace != null)
          PopupMenuItem(
            value: _MoreButtonAction.addRace,
            child: Row(
              children: [
                const Icon(Icons.emoji_events),
                const GapHorizontal8(),
                Text(str.addRace),
              ],
            ),
          ),
      ],
    );
  }

  void _onSelected(_MoreButtonAction option) {
    switch (option) {
      case _MoreButtonAction.editHealthMeasurement:
        onEditHealthMeasurement!();
        break;
      case _MoreButtonAction.addWorkout:
        onAddWorkout!();
        break;
      case _MoreButtonAction.addRace:
        onAddRace!();
        break;
    }
  }
}

enum _MoreButtonAction { editHealthMeasurement, addWorkout, addRace }

class _ValueWithLabel extends StatelessWidget {
  final String label;
  final String? value;

  const _ValueWithLabel({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelMedium(label),
        const Gap8(),
        NullableText(value),
      ],
    );
  }
}
