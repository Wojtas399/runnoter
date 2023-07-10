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
              _AddActivityButton(date: day.date),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              ...day.workouts.map(
                (workout) => ActivityItem(
                  activity: workout,
                  onPressed: () => _onWorkoutPressed(workout.id),
                ),
              ),
              ...day.races.map(
                (race) => ActivityItem(
                  activity: race,
                  onPressed: () => _onRacePressed(race.id),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onWorkoutPressed(String workoutId) {
    navigateTo(
      route: WorkoutPreviewRoute(workoutId: workoutId),
    );
  }

  void _onRacePressed(String raceId) {
    navigateTo(
      route: RacePreviewRoute(
        raceId: raceId,
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
