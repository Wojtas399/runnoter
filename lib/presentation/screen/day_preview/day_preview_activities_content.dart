part of 'day_preview_screen.dart';

class _ActivitiesContent extends StatelessWidget {
  const _ActivitiesContent();

  @override
  Widget build(BuildContext context) {
    final DayPreviewCubit cubit = context.watch<DayPreviewCubit>();

    if (cubit.state.workouts == null && cubit.state.workouts == null) {
      return const LoadingInfo();
    } else if (cubit.areThereActivities) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _Activities(
            workouts: cubit.state.workouts,
            competitions: cubit.state.competitions,
          ),
        ),
      );
    }
    return EmptyContentInfo(
      title: Str.of(context).dayPreviewNoActivitiesTitle,
      subtitle: cubit.isPastDate
          ? Str.of(context).dayPreviewNoActivitiesMessagePastDay
          : Str.of(context).dayPreviewNoActivitiesMessageFutureDay,
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
