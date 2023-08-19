import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../dependency_injection.dart';
import '../../../domain/service/auth_service.dart';
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

  Future<void> _onSelected(
    BuildContext context,
    _ActivityType activityType,
  ) async {
    final String dateStr = date.toPathFormat();
    final String? loggedUserId = await getIt<AuthService>().loggedUserId$.first;
    switch (activityType) {
      case _ActivityType.workout:
        navigateTo(
          WorkoutCreatorRoute(userId: loggedUserId, date: dateStr),
        );
        break;
      case _ActivityType.race:
        navigateTo(
          RaceCreatorRoute(userId: loggedUserId, dateStr: dateStr),
        );
        break;
    }
  }
}

enum _ActivityType { workout, race }
