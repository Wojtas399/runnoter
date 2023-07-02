part of 'workout_creator_screen.dart';

class _WorkoutStageItem extends StatelessWidget {
  final int index;
  final WorkoutStage workoutStage;

  const _WorkoutStageItem({
    super.key,
    required this.index,
    required this.workoutStage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onPressed(context);
      },
      child: SizedBox(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Description(workoutStage: workoutStage),
                  const SizedBox(width: 8),
                  _DeleteButton(workoutIndex: index),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final bloc = context.read<WorkoutCreatorBloc>();
    final WorkoutStage? updatedWorkoutStage = await showFullScreenDialog(
      context: context,
      dialog: WorkoutStageCreatorScreen(stage: workoutStage),
    );
    if (updatedWorkoutStage != null) {
      bloc.add(
        WorkoutCreatorEventWorkoutStageUpdated(
          stageIndex: index,
          workoutStage: updatedWorkoutStage,
        ),
      );
    }
  }
}

class _Description extends StatelessWidget {
  final WorkoutStage workoutStage;

  const _Description({
    required this.workoutStage,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            workoutStage.toUIFormat(context),
          ),
        ],
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final int workoutIndex;

  const _DeleteButton({
    required this.workoutIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        onPressed: () {
          _onPressed(context, workoutIndex);
        },
        icon: const Icon(
          Icons.close,
        ),
        iconSize: 20,
        padding: EdgeInsets.zero,
      ),
    );
  }

  void _onPressed(BuildContext context, int workoutIndex) {
    context.read<WorkoutCreatorBloc>().add(
          WorkoutCreatorEventDeleteWorkoutStage(index: workoutIndex),
        );
  }
}
