part of 'workout_preview_screen.dart';

class _Workout extends StatelessWidget {
  const _Workout();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentWithLabel(
                label: str.workoutPreviewWorkoutDate,
                content: const _WorkoutDate(),
              ),
              const SizedBox(height: 16),
              ContentWithLabel(
                label: str.workoutPreviewWorkoutStages,
                content: const _WorkoutStages(),
              ),
              const SizedBox(height: 16),
              ContentWithLabel(
                label: str.workoutPreviewTotalDistance,
                content: const _WorkoutDistance(),
              ),
              const SizedBox(height: 16),
              ContentWithLabel(
                label: str.runStatus,
                content: const _RunStatus(),
              ),
            ],
          ),
          const _RunStatusButton(),
        ],
      ),
    );
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
      (WorkoutPreviewBloc bloc) => bloc.state.stages,
    );

    return NullableText(stages?.toTotalDistanceDescription(context));
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
    final WorkoutPreviewBloc bloc = context.read<WorkoutPreviewBloc>();
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
