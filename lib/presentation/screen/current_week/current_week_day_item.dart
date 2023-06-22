part of 'current_week_screen.dart';

class DayItem extends StatelessWidget {
  final Day day;

  const DayItem({
    super.key,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
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
              _AddWorkoutButton(date: day.date),
            ],
          ),
          Column(
            children: day.workouts.map((e) => Text(e.name)).toList(),
          ),
        ],
      ),
    );
  }
}

class _AddWorkoutButton extends StatelessWidget {
  final DateTime date;

  const _AddWorkoutButton({
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _onPressed(context);
      },
      icon: const Icon(Icons.add),
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(
      context: context,
      route: WorkoutCreatorRoute(
        creatorArguments: WorkoutCreatorAddModeArguments(date: date),
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
      child: TitleMedium(
        date.toFullDate(context),
        color: isToday ? Theme.of(context).canvasColor : null,
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
