import 'package:flutter/material.dart';

import '../../../domain/bloc/current_week/current_week_cubit.dart';
import '../../../domain/entity/run_status.dart';
import '../../../domain/entity/workout.dart';
import '../../../domain/entity/workout_stage.dart';
import '../../config/navigation/routes.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/run_status_formatter.dart';
import '../../formatter/workout_stage_formatter.dart';
import '../../service/navigator_service.dart';

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
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 4,
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
                  _RunStatus(
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
        date: day.date,
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
      child: Text(
        date.toFullDate(context),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isToday ? Theme.of(context).canvasColor : null,
            ),
      ),
    );
  }
}

class _RunStatus extends StatelessWidget {
  final RunStatus status;

  const _RunStatus({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 8,
      ),
      child: Icon(
        status.toIcon(),
        color: status.toColor(),
      ),
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
