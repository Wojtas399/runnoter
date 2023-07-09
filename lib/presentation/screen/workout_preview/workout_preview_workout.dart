part of 'workout_preview_screen.dart';

class _Workout extends StatelessWidget {
  const _Workout();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    const Widget gap = SizedBox(height: 16);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            gap,
            ContentWithLabel(
              label: str.workoutPreviewWorkoutDate,
              content: const _WorkoutDate(),
            ),
            gap,
            ContentWithLabel(
              label: str.workoutPreviewWorkoutStages,
              content: const _WorkoutStages(),
            ),
            gap,
            ContentWithLabel(
              label: str.workoutPreviewTotalDistance,
              content: const _WorkoutDistance(),
            ),
            gap,
            ContentWithLabel(
              label: str.runStatus,
              content: const _RunStatus(),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const _RunStatusButton(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _WorkoutName(),
        if (!context.isMobileSize) const _WorkoutActions(),
      ],
    );
  }
}

class _WorkoutName extends StatelessWidget {
  const _WorkoutName();

  @override
  Widget build(BuildContext context) {
    final String? name = context.select(
      (WorkoutPreviewBloc bloc) => bloc.state.workoutName,
    );

    return TitleLarge(name ?? '');
  }
}

class _WorkoutDate extends StatelessWidget {
  const _WorkoutDate();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (WorkoutPreviewBloc bloc) => bloc.state.date,
    );

    return NullableText(
      date?.toFullDate(context),
    );
  }
}

class _WorkoutStages extends StatelessWidget {
  const _WorkoutStages();

  @override
  Widget build(BuildContext context) {
    final List<WorkoutStage>? stages = context.select(
      (WorkoutPreviewBloc bloc) => bloc.state.stages,
    );

    if (stages == null) {
      return const NullableText(null);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...stages.asMap().entries.map(
              (MapEntry<int, WorkoutStage> entry) => Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key < stages.length ? 8 : 0,
                ),
                child: Text(
                  '${entry.key + 1}. ${entry.value.toUIFormat(context)}',
                ),
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
      (WorkoutPreviewBloc bloc) => bloc.state.stages,
    );

    return NullableText(stages?.toUIDetailedTotalDistance(context));
  }
}

class _RunStatus extends StatelessWidget {
  const _RunStatus();

  @override
  Widget build(BuildContext context) {
    final RunStatus? runStatus = context.select(
      (WorkoutPreviewBloc bloc) => bloc.state.runStatus,
    );

    return runStatus == null
        ? const NullableText(null)
        : RunStatusInfo(runStatus: runStatus);
  }
}

class _RunStatusButton extends StatelessWidget {
  const _RunStatusButton();

  @override
  Widget build(BuildContext context) {
    final RunStatus? runStatus = context.select(
      (WorkoutPreviewBloc bloc) => bloc.state.runStatus,
    );
    String label = Str.of(context).runStatusEditStatus;
    if (runStatus is RunStatusPending) {
      label = Str.of(context).runStatusFinish;
    }

    return BigButton(
      label: label,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(
      context: context,
      route: RunStatusCreatorRoute(
        creatorArguments: WorkoutRunStatusCreatorArguments(
          entityId: context.read<WorkoutPreviewBloc>().workoutId,
        ),
      ),
    );
  }
}
