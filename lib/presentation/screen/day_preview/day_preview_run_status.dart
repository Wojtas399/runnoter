part of 'day_preview_screen.dart';

class _RunStatus extends StatelessWidget {
  const _RunStatus();

  @override
  Widget build(BuildContext context) {
    final RunStatus? status = context.select(
      (DayPreviewBloc bloc) => bloc.state.runStatus,
    );

    if (status == null) {
      return const NullableText(null);
    }
    return Column(
      children: [
        _RunStatusName(status: status),
        if (status is RunStats)
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

class _RunStatusName extends StatelessWidget {
  final RunStatus status;

  const _RunStatusName({
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
  final RunStats status;

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
                  value: '${status.avgHeartRate} ${str.heartRateUnit}',
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
    final RunStatus? runStatus = context.select(
      (DayPreviewBloc bloc) => bloc.state.runStatus,
    );

    String? moodRateStr;
    if (runStatus is RunStats) {
      moodRateStr = runStatus.moodRate.toUIFormat();
    }

    return NullableText(moodRateStr);
  }
}

class _WorkoutComment extends StatelessWidget {
  const _WorkoutComment();

  @override
  Widget build(BuildContext context) {
    final RunStatus? runStatus = context.select(
      (DayPreviewBloc bloc) => bloc.state.runStatus,
    );
    String? comment;
    if (runStatus is RunStats) {
      comment = runStatus.comment;
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
