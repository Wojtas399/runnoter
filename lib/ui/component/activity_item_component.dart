import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/entity/race.dart';
import '../../data/entity/workout.dart';
import '../../data/model/activity.dart';
import '../formatter/activity_status_formatter.dart';
import '../formatter/list_of_workout_stages_formatter.dart';
import 'text/body_text_components.dart';
import 'text/label_text_components.dart';

class ActivityItem extends StatelessWidget {
  final Activity activity;
  final VoidCallback onPressed;

  const ActivityItem({
    super.key,
    required this.activity,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Label(activity: activity),
              Row(
                children: [
                  if (activity is Race) const _RaceMark(),
                  Icon(
                    activity.status.toIcon(),
                    color: activity.status.toColor(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final Activity activity;

  const _Label({
    required this.activity,
  });

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
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      margin: const EdgeInsets.only(right: 8),
      child: LabelMedium(
        Str.of(context).race,
        color: Theme.of(context).canvasColor,
      ),
    );
  }
}
