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
          Column(
            children: [
              ...day.workouts.map(
                (workout) => ActivityItem(
                  activity: workout,
                  onPressed: () {
                    _onWorkoutPressed(context, workout.id);
                  },
                ),
              ),
              ...day.competitions.map(
                (competition) => ActivityItem(
                  activity: competition,
                  onPressed: () {
                    _onCompetitionPressed(context, competition.id);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onWorkoutPressed(BuildContext context, String workoutId) {
    navigateTo(
      context: context,
      route: WorkoutPreviewRoute(workoutId: workoutId),
    );
  }

  void _onCompetitionPressed(BuildContext context, String competitionId) {
    navigateTo(
      context: context,
      route: CompetitionPreviewRoute(
        competitionId: competitionId,
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
