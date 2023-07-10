part of 'day_preview_dialog.dart';

class _ActivitiesContent extends StatelessWidget {
  const _ActivitiesContent();

  @override
  Widget build(BuildContext context) {
    final DayPreviewCubit cubit = context.watch<DayPreviewCubit>();

    if (cubit.state.workouts == null && cubit.state.workouts == null) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadingInfo(),
        ],
      );
    } else if (cubit.areThereActivities) {
      return _Activities(
        workouts: cubit.state.workouts,
        races: cubit.state.races,
      );
    }
    final str = Str.of(context);
    return EmptyContentInfo(
      title: str.dayPreviewNoActivitiesTitle,
      subtitle: cubit.isPastDate
          ? str.dayPreviewNoActivitiesMessagePastDay
          : str.dayPreviewNoActivitiesMessageFutureDay,
    );
  }
}

class _Activities extends StatelessWidget {
  final List<Workout>? workouts;
  final List<Race>? races;

  const _Activities({
    required this.workouts,
    required this.races,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...?workouts?.map(
          (workout) => ActivityItem(
            activity: workout,
            onPressed: () {
              _onWorkoutPressed(context, workout.id);
            },
          ),
        ),
        ...?races?.map(
          (race) => ActivityItem(
            activity: race,
            onPressed: () {
              _onRacePressed(context, race.id);
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

  void _onRacePressed(BuildContext context, String raceId) {
    navigateTo(
      context: context,
      route: RacePreviewRoute(raceId: raceId),
    );
  }
}
