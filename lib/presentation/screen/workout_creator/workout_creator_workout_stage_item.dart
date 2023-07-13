part of 'workout_creator_screen.dart';

class _WorkoutStageItem extends StatefulWidget {
  final int index;
  final WorkoutStage workoutStage;

  const _WorkoutStageItem({
    super.key,
    required this.index,
    required this.workoutStage,
  });

  @override
  State<StatefulWidget> createState() => _WorkoutStageItemState();
}

class _WorkoutStageItemState extends State<_WorkoutStageItem> {
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ReorderableDelayedDragStartListener(
          index: widget.index,
          child: Card(
            key: globalKey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BodyMedium(
                      widget.workoutStage.toUIFormat(context),
                    ),
                  ),
                  _WorkoutStageActions(
                    stageIndex: widget.index,
                    stage: widget.workoutStage,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkoutStageActions extends StatelessWidget {
  final int stageIndex;
  final WorkoutStage stage;

  const _WorkoutStageActions({
    required this.stageIndex,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double iconSize = 20;
    if (context.isMobileSize) {
      return EditDeletePopupMenu(
        onEditSelected: () => _editWorkoutStage(context),
        onDeleteSelected: () => _deleteWorkoutStage(context),
      );
    }
    return Row(
      children: [
        IconButton(
          onPressed: () => _editWorkoutStage(context),
          icon: Icon(
            Icons.edit_outlined,
            size: iconSize,
            color: theme.colorScheme.primary,
          ),
        ),
        IconButton(
          onPressed: () => _deleteWorkoutStage(context),
          icon: Icon(
            Icons.delete_outline,
            size: iconSize,
            color: theme.colorScheme.error,
          ),
        ),
      ],
    );
  }

  Future<void> _editWorkoutStage(BuildContext context) async {
    final bloc = context.read<WorkoutCreatorBloc>();
    final WorkoutStage? updatedWorkoutStage =
        await showDialogDependingOnScreenSize(
      WorkoutStageCreatorDialog(stage: stage),
    );
    if (updatedWorkoutStage != null) {
      bloc.add(
        WorkoutCreatorEventWorkoutStageUpdated(
          stageIndex: stageIndex,
          workoutStage: updatedWorkoutStage,
        ),
      );
    }
  }

  void _deleteWorkoutStage(BuildContext context) {
    context.read<WorkoutCreatorBloc>().add(
          WorkoutCreatorEventDeleteWorkoutStage(index: stageIndex),
        );
  }
}
