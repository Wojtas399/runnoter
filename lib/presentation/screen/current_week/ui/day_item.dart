import 'package:flutter/material.dart';

import '../../../../domain/model/workout.dart';
import '../../../../domain/model/workout_stage.dart';
import '../../../../domain/model/workout_status.dart';
import '../../../config/navigation/routes.dart';
import '../../../formatter/date_formatter.dart';
import '../../../formatter/workout_stage_formatter.dart';
import '../../../formatter/workout_status_formatter.dart';
import '../../../service/navigator_service.dart';
import '../current_week_cubit.dart';

class DayItem extends StatelessWidget {
  final Day day;

  const DayItem({
    super.key,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _onPressed(context);
      },
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _Date(
                  date: day.date,
                  isToday: day.isToday,
                ),
                if (day.workout?.status != null)
                  _WorkoutStatus(
                    status: day.workout!.status,
                  ),
              ],
            ),
            if (day.workout != null) _Workout(workout: day.workout!),
          ],
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(
      context: context,
      route: DayPreviewRoute(
        arguments: day.date,
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isToday
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        date.toUIFormat(context),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isToday
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).textTheme.titleMedium?.color,
            ),
      ),
    );
  }
}

class _WorkoutStatus extends StatelessWidget {
  final WorkoutStatus status;

  const _WorkoutStatus({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 8,
      ),
      child: status.toIcon(),
    );
  }
}

class _Workout extends StatelessWidget {
  final Workout workout;

  const _Workout({
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...workout.stages.asMap().entries.map(
                (MapEntry<int, WorkoutStage> entry) => Text(
                  '${entry.key + 1}. ${entry.value.toUIFormat(context)}',
                ),
              ),
        ],
      ),
    );
  }
}
