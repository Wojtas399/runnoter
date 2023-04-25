part of 'day_preview_screen.dart';

class _WorkoutContent extends StatelessWidget {
  const _WorkoutContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Date(),
            SizedBox(height: 24),
            _WorkoutName(),
            SizedBox(height: 16),
            _WorkoutStages(),
            SizedBox(height: 16),
            _WorkoutDistance(),
            SizedBox(height: 16),
            _WorkoutStatus(),
          ],
        ),
        const _WorkoutStatusButtons(),
      ],
    );
  }
}

class _WorkoutName extends StatelessWidget {
  const _WorkoutName();

  @override
  Widget build(BuildContext context) {
    final String? workoutName = context.select(
      (DayPreviewBloc bloc) => bloc.state.workout?.name,
    );

    if (workoutName == null) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nazwa',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(workoutName),
      ],
    );
  }
}

class _WorkoutStages extends StatelessWidget {
  const _WorkoutStages();

  @override
  Widget build(BuildContext context) {
    final List<WorkoutStage>? stages = context.select(
      (DayPreviewBloc bloc) => bloc.state.workout?.stages,
    );

    if (stages == null) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Etapy',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Wrap(
          direction: Axis.vertical,
          spacing: 8,
          children: [
            ...stages.asMap().entries.map(
                  (MapEntry<int, WorkoutStage> entry) => Text(
                    '${entry.key + 1}. ${entry.value.toUIFormat(context)}',
                  ),
                ),
          ],
        ),
      ],
    );
  }
}

class _WorkoutDistance extends StatelessWidget {
  const _WorkoutDistance();

  @override
  Widget build(BuildContext context) {
    final List<WorkoutStage>? stages = context.select(
      (DayPreviewBloc bloc) => bloc.state.workout?.stages,
    );

    if (stages == null) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dystans',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          stages.toTotalDistanceDescription(context),
        ),
      ],
    );
  }
}

class _WorkoutStatus extends StatelessWidget {
  const _WorkoutStatus();

  @override
  Widget build(BuildContext context) {
    final WorkoutStatus? status = context.select(
      (DayPreviewBloc bloc) => bloc.state.workout?.status,
    );

    if (status == null) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Row(
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
        ),
      ],
    );
  }
}
