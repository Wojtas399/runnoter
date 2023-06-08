part of 'day_preview_screen.dart';

class _WorkoutContent extends StatelessWidget {
  const _WorkoutContent();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Date(),
            const SizedBox(height: 24),
            _WorkoutParam(
              label: str.dayPreviewWorkoutName,
              child: const _WorkoutName(),
            ),
            const SizedBox(height: 16),
            _WorkoutParam(
              label: str.dayPreviewWorkoutStages,
              child: const _WorkoutStages(),
            ),
            const SizedBox(height: 16),
            _WorkoutParam(
              label: str.dayPreviewTotalDistance,
              child: const _WorkoutDistance(),
            ),
            const SizedBox(height: 16),
            _WorkoutParam(
              label: str.dayPreviewRunStatus,
              child: const _RunStatus(),
            ),
          ],
        ),
        const _RunStatusButton(),
      ],
    );
  }
}

class _WorkoutName extends StatelessWidget {
  const _WorkoutName();

  @override
  Widget build(BuildContext context) {
    final String? workoutName = context.select(
      (DayPreviewBloc bloc) => bloc.state.workoutName,
    );

    return NullableText(workoutName);
  }
}

class _WorkoutStages extends StatelessWidget {
  const _WorkoutStages();

  @override
  Widget build(BuildContext context) {
    final List<WorkoutStage>? stages = context.select(
      (DayPreviewBloc bloc) => bloc.state.stages,
    );

    if (stages == null) {
      return const NullableText(null);
    }

    return Wrap(
      direction: Axis.vertical,
      spacing: 8,
      children: [
        ...stages.asMap().entries.map(
              (MapEntry<int, WorkoutStage> entry) => Text(
                '${entry.key + 1}. ${entry.value.toUIFormat(context)}',
              ),
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
      (DayPreviewBloc bloc) => bloc.state.stages,
    );

    return NullableText(stages?.toTotalDistanceDescription(context));
  }
}

class _RunStatusButton extends StatelessWidget {
  const _RunStatusButton();

  @override
  Widget build(BuildContext context) {
    final RunStatus? runStatus = context.select(
      (DayPreviewBloc bloc) => bloc.state.runStatus,
    );
    String label = Str.of(context).dayPreviewChangeStatusButton;
    if (runStatus is RunStatusPending) {
      label = Str.of(context).dayPreviewFinishWorkoutButton;
    }

    return BigButton(
      label: label,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    final DayPreviewBloc bloc = context.read<DayPreviewBloc>();
    final String? workoutId = bloc.state.workoutId;
    if (workoutId == null) {
      return;
    }
    navigateTo(
      context: context,
      route: RunStatusCreatorRoute(
        creatorArguments: WorkoutRunStatusCreatorArguments(
          entityId: workoutId,
        ),
      ),
    );
  }
}

class _WorkoutParam extends StatelessWidget {
  final String label;
  final Widget child;

  const _WorkoutParam({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}
