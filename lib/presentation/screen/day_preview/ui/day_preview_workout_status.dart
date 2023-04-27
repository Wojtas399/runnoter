part of 'day_preview_screen.dart';

class _WorkoutStatus extends StatelessWidget {
  const _WorkoutStatus();

  @override
  Widget build(BuildContext context) {
    final WorkoutStatus? status = context.select(
      (DayPreviewBloc bloc) => bloc.state.workoutStatus,
    );

    if (status == null) {
      return const NullableText(null);
    }
    return Column(
      children: [
        _WorkoutStatusName(status: status),
        if (status is FinishedWorkout)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _WorkoutStats(status: status),
                const SizedBox(height: 16),
                _WorkoutParam(
                  label: AppLocalizations.of(context)!
                      .day_preview_screen_comment_section_label,
                  child: const _WorkoutComment(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _WorkoutStatusName extends StatelessWidget {
  final WorkoutStatus status;

  const _WorkoutStatusName({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          status.toIcon(),
          color: status.toColor(),
        ),
        const SizedBox(width: 16),
        Text(
          status.toLabel(context),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: status.toColor(),
              ),
        ),
      ],
    );
  }
}

class _WorkoutStats extends StatelessWidget {
  final FinishedWorkout status;

  const _WorkoutStats({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _WorkoutStatParam(
                  label: AppLocalizations.of(context)!
                      .day_preview_screen_workout_status_covered_distance,
                  value: '${status.coveredDistanceInKm} km',
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: _WorkoutStatParam(
                  label: AppLocalizations.of(context)!
                      .day_preview_screen_workout_status_mood_rate,
                  value: status.moodRate.toUIFormat(),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _WorkoutStatParam(
                  label: AppLocalizations.of(context)!
                      .day_preview_screen_workout_status_avg_pace,
                  value: status.avgPace.toUIFormat(),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: _WorkoutStatParam(
                  label: AppLocalizations.of(context)!
                      .day_preview_screen_workout_status_avg_heart_rate,
                  value: '${status.avgHeartRate} ud/min',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WorkoutComment extends StatelessWidget {
  const _WorkoutComment();

  @override
  Widget build(BuildContext context) {
    final WorkoutStatus? workoutStatus = context.select(
      (DayPreviewBloc bloc) => bloc.state.workoutStatus,
    );
    String? comment;
    if (workoutStatus is FinishedWorkout) {
      comment = workoutStatus.comment;
    }

    return NullableText(comment);
  }
}

class _WorkoutStatParam extends StatelessWidget {
  final String label;
  final String value;

  const _WorkoutStatParam({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}
