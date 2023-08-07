import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../component/gap/gap_horizontal_components.dart';
import '../../config/navigation/router.dart';
import '../../formatter/date_formatter.dart';
import '../../service/navigator_service.dart';

class CurrentWeekAddActivityButton extends StatelessWidget {
  final DateTime date;

  const CurrentWeekAddActivityButton({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return PopupMenuButton<_ActivityType>(
      icon: const Icon(Icons.add),
      onSelected: (_ActivityType type) => _onSelected(context, type),
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

  void _onSelected(BuildContext context, _ActivityType activityType) {
    final String dateStr = date.toPathFormat();
    switch (activityType) {
      case _ActivityType.workout:
        navigateTo(
          WorkoutCreatorRoute(date: dateStr),
        );
        break;
      case _ActivityType.race:
        navigateTo(
          RaceCreatorRoute(dateStr: dateStr),
        );
        break;
    }
  }
}

enum _ActivityType {
  workout,
  race,
}
