import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../domain/additional_model/calendar_week_day.dart';
import '../../domain/entity/activity.dart';
import '../../domain/entity/race.dart';
import '../../domain/entity/workout.dart';
import '../formatter/activity_status_formatter.dart';
import '../formatter/date_formatter.dart';
import '../formatter/list_of_workout_stages_formatter.dart';
import 'gap/gap_components.dart';
import 'gap/gap_horizontal_components.dart';
import 'health_measurement_info_component.dart';
import 'text/body_text_components.dart';
import 'text/label_text_components.dart';
import 'text/title_text_components.dart';

class WeekDayItem extends StatelessWidget {
  final CalendarWeekDay day;
  final VoidCallback? onPressed;

  const WeekDayItem({super.key, required this.day, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Date(date: day.date, isToday: day.isTodayDay),
              const Gap16(),
              HealthMeasurementInfo(healthMeasurement: day.healthMeasurement),
              const Gap16(),
              _Activities(workouts: day.workouts, races: day.races),
            ],
          ),
        ),
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
    return Column(
      children: [
        if (workouts.isNotEmpty || races.isNotEmpty) ...[
          ...races.map((Race race) => _ActivityItem(race)),
          ...workouts.map((Workout workout) => _ActivityItem(workout)),
        ],
        if (workouts.isEmpty && races.isEmpty) ...[
          const Gap8(),
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

  const _Date({required this.date, required this.isToday});

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

class _ActivityItem extends StatelessWidget {
  final Activity activity;

  const _ActivityItem(this.activity);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 8),
      title: _ActivityDescription(activity: activity),
      leading: Icon(MdiIcons.circleMedium),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (activity is Race) ...[
            const _RaceMark(),
            const GapHorizontal8(),
          ],
          Icon(
            activity.status.toIcon(),
            color: activity.status.toColor(context),
          ),
        ],
      ),
    );
  }
}

class _ActivityDescription extends StatelessWidget {
  final Activity activity;

  const _ActivityDescription({required this.activity});

  @override
  Widget build(BuildContext context) {
    final Activity activity = this.activity;
    String label = activity.name;
    if (activity is Workout) {
      final String totalDistance = activity.stages.toUITotalDistance(context);
      if (!(totalDistance.substring(0, 3) == '0.0')) {
        label += ' ($totalDistance)';
      }
    }

    return BodyMedium(label);
  }
}

class _RaceMark extends StatelessWidget {
  const _RaceMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(right: 8),
      child: LabelMedium(
        Str.of(context).race,
        color: Theme.of(context).canvasColor,
      ),
    );
  }
}
