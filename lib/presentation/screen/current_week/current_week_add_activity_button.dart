part of 'current_week_screen.dart';

class _AddActivityButton extends StatelessWidget {
  final DateTime date;

  const _AddActivityButton({
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
              const SizedBox(width: 8),
              Text(str.workout),
            ],
          ),
        ),
        PopupMenuItem(
          value: _ActivityType.race,
          child: Row(
            children: [
              const Icon(Icons.emoji_events),
              const SizedBox(width: 8),
              Text(str.race),
            ],
          ),
        ),
      ],
    );
  }

  void _onSelected(BuildContext context, _ActivityType activityType) {
    switch (activityType) {
      case _ActivityType.workout:
        navigateTo(
          WorkoutCreatorRoute(date: date.toPathFormat()),
        );
        break;
      case _ActivityType.race:
        navigateTo(
          RaceCreatorRoute(
            arguments: RaceCreatorArguments(date: date),
          ),
        );
        break;
    }
  }
}

enum _ActivityType {
  workout,
  race,
}
