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
                  label: Str.of(context).dayPreviewMoodRate,
                  child: const _MoodRate(),
                ),
                const SizedBox(height: 16),
                _WorkoutParam(
                  label: Str.of(context).dayPreviewComment,
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
    final str = Str.of(context);

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _WorkoutStatParam(
                  label: str.dayPreviewCoveredDistance,
                  value: '${status.coveredDistanceInKm} km',
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
                  label: str.dayPreviewAveragePace,
                  value: status.avgPace.toUIFormat(),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: _WorkoutStatParam(
                  label: str.dayPreviewAverageHeartRate,
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

class _MoodRate extends StatelessWidget {
  const _MoodRate();

  @override
  Widget build(BuildContext context) {
    final WorkoutStatus? workoutStatus = context.select(
      (DayPreviewBloc bloc) => bloc.state.workoutStatus,
    );

    String? moodRateStr;
    if (workoutStatus is FinishedWorkout) {
      moodRateStr = workoutStatus.moodRate.toUIFormat();
    }

    return NullableText(moodRateStr);
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
