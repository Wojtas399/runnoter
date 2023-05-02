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
          children: [
            const _Date(),
            const SizedBox(height: 24),
            _WorkoutParam(
              label: AppLocalizations.of(context)!
                  .day_preview_screen_workout_name_section_label,
              child: const _WorkoutName(),
            ),
            const SizedBox(height: 16),
            _WorkoutParam(
              label: AppLocalizations.of(context)!
                  .day_preview_screen_workout_stages_section_label,
              child: const _WorkoutStages(),
            ),
            const SizedBox(height: 16),
            _WorkoutParam(
              label: AppLocalizations.of(context)!
                  .day_preview_screen_total_distance_section_label,
              child: const _WorkoutDistance(),
            ),
            const SizedBox(height: 16),
            _WorkoutParam(
              label: AppLocalizations.of(context)!
                  .day_preview_screen_workout_status_section_label,
              child: const _WorkoutStatus(),
            ),
          ],
        ),
        const _WorkoutFinishButton(),
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

class _WorkoutFinishButton extends StatelessWidget {
  const _WorkoutFinishButton();

  @override
  Widget build(BuildContext context) {
    return BigButton(
      label: AppLocalizations.of(context)!
          .day_preview_screen_finish_workout_button_label,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    final String? workoutId = context.read<DayPreviewBloc>().state.workoutId;
    if (workoutId != null) {
      navigateTo(
        context: context,
        route: WorkoutStatusCreatorRoute(
          creatorArguments: WorkoutStatusCreatorFinishWorkoutArguments(
            workoutId: workoutId,
          ),
        ),
      );
    }
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
