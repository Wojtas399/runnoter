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
      onPressed: () {
        _onPressed(context);
      },
      icon: const Icon(Icons.add),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final ActivityType? activityType = await _askForActivityType(context);
    if (activityType != null && mounted) {
      switch (activityType) {
        case ActivityType.workout:
          navigateTo(
            context: context,
            route: WorkoutCreatorRoute(
              creatorArguments: WorkoutCreatorAddModeArguments(
                date: widget.date,
              ),
            ),
          );
          break;
        case ActivityType.race:
          navigateTo(
            context: context,
            route: const CompetitionCreatorRoute(),
          );
          break;
      }
    }
  }

  Future<ActivityType?> _askForActivityType(BuildContext context) async {
    return await askForAction<ActivityType>(
      context: context,
      title: Str.of(context).currentWeekActivityActionSheetTitle,
      actions: [
        ActionSheetItem(
          id: ActivityType.workout,
          label: Str.of(context).workout,
          iconData: Icons.directions_run,
        ),
        ActionSheetItem(
          id: ActivityType.race,
          label: Str.of(context).race,
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
