part of 'workout_creator_screen.dart';

class _WorkoutStagesSection extends StatelessWidget {
  const _WorkoutStagesSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Title(),
          SizedBox(height: 8),
          _WorkoutStagesList(),
          SizedBox(height: 16),
          _AddStageButton()
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.workout_creator_screen_workout_stages,
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}

class _AddStageButton extends StatelessWidget {
  const _AddStageButton();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            _onPressed(context);
          },
          icon: const Icon(Icons.add),
          label: Text(
            AppLocalizations.of(context)!
                .workout_creator_screen_add_stage_button_label,
          ),
        ),
      ],
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final WorkoutCreatorBloc bloc = context.read<WorkoutCreatorBloc>();
    final WorkoutStage? workoutStage = await showFullScreenDialog(
      context: context,
      dialog: const WorkoutStageCreatorScreen(),
    );
    if (workoutStage != null) {
      bloc.add(
        WorkoutCreatorEventWorkoutStageAdded(
          workoutStage: workoutStage,
        ),
      );
    }
  }
}
