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
          _WorkoutStages(),
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
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

class _WorkoutStages extends StatelessWidget {
  const _WorkoutStages();

  @override
  Widget build(BuildContext context) {
    final List<WorkoutStage> stages = context.select(
      (WorkoutCreatorBloc bloc) => bloc.state.stages,
    );

    if (stages.isEmpty) {
      return const _NoWorkoutStagesInfo();
    }
    if (stages.length == 1) {
      return _WorkoutStageItem(
        index: 0,
        workoutStage: stages.first,
      );
    }
    return _ListOfWorkoutStages(
      workoutStages: stages,
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

class _NoWorkoutStagesInfo extends StatelessWidget {
  const _NoWorkoutStagesInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.workout_creator_screen_no_stages_info,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!
                .workout_creator_screen_add_stage_instruction,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ListOfWorkoutStages extends StatelessWidget {
  final List<WorkoutStage> workoutStages;

  const _ListOfWorkoutStages({
    required this.workoutStages,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      proxyDecorator: (Widget child, _, Animation<double> animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) => Material(
            elevation: 10,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: child,
          ),
          child: child,
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        //TODO
      },
      children: [
        for (int i = 0; i < workoutStages.length; i++)
          _WorkoutStageItem(
            key: Key('$i'),
            index: i,
            workoutStage: workoutStages[i],
          ),
      ],
    );
  }
}
