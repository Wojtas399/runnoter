part of 'day_preview_screen.dart';

class _ActivitiesContent extends StatelessWidget {
  const _ActivitiesContent();

  @override
  Widget build(BuildContext context) {
    final List<Workout>? workouts = context.select(
      (DayPreviewCubit cubit) => cubit.state.workouts,
    );
    final List<Competition>? competitions = context.select(
      (DayPreviewCubit cubit) => cubit.state.competitions,
    );

    if (workouts == null && competitions == null) {
      return const LoadingInfo();
    }
    return _Activities(
      workouts: workouts,
      competitions: competitions,
    );
  }
}

class _Activities extends StatelessWidget {
  final List<Workout>? workouts;
  final List<Competition>? competitions;

  const _Activities({
    required this.workouts,
    required this.competitions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...?workouts?.map(
          (workout) => ActivityItem(
            activity: workout,
            onPressed: () {
              _onWorkoutPressed(context, workout.id);
            },
          ),
        ),
        ...?competitions?.map(
          (competition) => ActivityItem(
            activity: competition,
            onPressed: () {
              _onCompetitionPressed(context, competition.id);
            },
          ),
        ),
      ],
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
      route: CompetitionPreviewRoute(competitionId: competitionId),
    );
  }
}
