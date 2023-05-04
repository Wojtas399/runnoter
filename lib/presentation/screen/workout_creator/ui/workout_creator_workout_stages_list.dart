part of 'workout_creator_screen.dart';

class _WorkoutStagesList extends StatelessWidget {
  const _WorkoutStagesList();

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
    return _ReorderableListOfWorkoutStages(
      workoutStages: stages,
    );
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
            Str.of(context)!.workout_creator_screen_no_stages_info,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Text(
            Str.of(context)!.workout_creator_screen_add_stage_instruction,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ReorderableListOfWorkoutStages extends StatefulWidget {
  final List<WorkoutStage> workoutStages;

  const _ReorderableListOfWorkoutStages({
    required this.workoutStages,
  });

  @override
  State<StatefulWidget> createState() => _ReorderableListOfWorkoutStagesState();
}

class _ReorderableListOfWorkoutStagesState
    extends State<_ReorderableListOfWorkoutStages> {
  List<WorkoutStage> _stages = [];

  @override
  void initState() {
    _stages = widget.workoutStages;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _ReorderableListOfWorkoutStages oldWidget) {
    _stages = widget.workoutStages;
    super.didUpdateWidget(oldWidget);
  }

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
        _onReorder(oldIndex, newIndex);
      },
      children: [
        for (int i = 0; i < _stages.length; i++)
          _WorkoutStageItem(
            key: Key('$i'),
            index: i,
            workoutStage: _stages[i],
          ),
      ],
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final WorkoutStage stage = _stages.removeAt(oldIndex);
      _stages.insert(newIndex, stage);
    });
    context.read<WorkoutCreatorBloc>().add(
          WorkoutCreatorEventWorkoutStagesOrderChanged(
            workoutStages: _stages,
          ),
        );
  }
}
