part of 'current_week_screen.dart';

class _AddActivityButton extends StatefulWidget {
  final DateTime date;

  const _AddActivityButton({
    required this.date,
  });

  @override
  State<StatefulWidget> createState() => _AddActivityButtonState();
}

class _AddActivityButtonState extends State<_AddActivityButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _onPressed,
      icon: const Icon(Icons.add),
    );
  }

  Future<void> _onPressed() async {
    final ActivityType? activityType = await _askForActivityType(context);
    if (activityType != null && mounted) {
      switch (activityType) {
        case ActivityType.workout:
          navigateTo(
            route: WorkoutCreatorRoute(
              creatorArguments: WorkoutCreatorAddModeArguments(
                date: widget.date,
              ),
            ),
          );
          break;
        case ActivityType.race:
          navigateTo(
            route: RaceCreatorRoute(
              arguments: RaceCreatorArguments(date: widget.date),
            ),
          );
          break;
      }
    }
  }

  Future<ActivityType?> _askForActivityType(BuildContext context) async {
    final str = Str.of(context);
    return await askForAction<ActivityType>(
      title: str.currentWeekActivityActionSheetTitle,
      actions: [
        ActionSheetItem(
          id: ActivityType.workout,
          label: str.workout,
          iconData: Icons.directions_run,
        ),
        ActionSheetItem(
          id: ActivityType.race,
          label: str.race,
          iconData: Icons.emoji_events,
        ),
      ],
    );
  }
}

enum ActivityType {
  workout,
  race,
}
