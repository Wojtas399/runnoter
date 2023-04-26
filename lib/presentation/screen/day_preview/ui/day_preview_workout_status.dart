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
            child: _WorkoutStats(status: status),
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
                  label: 'Pokonany dystans',
                  value: '${status.coveredDistanceInKm} km',
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: _WorkoutStatParam(
                  label: 'Samopoczucie',
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
                  label: 'Średnie tempo',
                  value: status.avgPace.toUIFormat(),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: _WorkoutStatParam(
                  label: 'Średnie tętno',
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
