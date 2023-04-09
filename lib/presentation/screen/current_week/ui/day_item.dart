import 'package:flutter/material.dart';

import '../../../../domain/model/workout.dart';
import '../../../../domain/model/workout_stage.dart';
import '../../../formatter/additional_workout_formatter.dart';
import '../../../formatter/date_formatter.dart';
import '../../../formatter/workout_stage_formatter.dart';
import '../current_week_cubit.dart';

class DayItem extends StatelessWidget {
  final Day day;

  const DayItem({
    super.key,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Date(
            date: day.date,
            isToday: day.isToday,
          ),
          if (day.workout != null) _Workout(workout: day.workout!),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isToday
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
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

class _Workout extends StatelessWidget {
  final Workout workout;

  const _Workout({
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...workout.stages.asMap().entries.map(
                (MapEntry<int, WorkoutStage> entry) => Text(
                  '${entry.key + 1}. ${entry.value.toUIFormat(context)}',
                ),
              ),
          if (workout.additionalWorkout != null)
            Text(
              '${workout.stages.length + 1}. ${workout.additionalWorkout!.toUIFormat(context)}',
            ),
        ],
      ),
    );
  }
}
