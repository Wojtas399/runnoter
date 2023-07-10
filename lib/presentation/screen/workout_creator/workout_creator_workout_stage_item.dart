part of 'workout_creator_screen.dart';

enum _WorkoutStageAction {
  edit,
  delete,
}

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
      child: Card(
        key: globalKey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: _onPressed,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BodyMedium(widget.workoutStage.toUIFormat(context)),
                _DragHandle(itemIndex: widget.index),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onPressed() async {
    final _WorkoutStageAction? action = await _askForAction();
    if (action == null || !mounted) return;
    switch (action) {
      case _WorkoutStageAction.edit:
        await _editWorkoutStage();
        break;
      case _WorkoutStageAction.delete:
        _deleteWorkoutStage();
        break;
    }
  }

  Future<_WorkoutStageAction?> _askForAction() async =>
      await askForMenuAction<_WorkoutStageAction>(
        context: context,
        boxGlobalKey: globalKey,
        actions: [
          ActionItem(
            id: _WorkoutStageAction.edit,
            iconData: Icons.edit_outlined,
            label: Str.of(context).edit,
          ),
          ActionItem(
            id: _WorkoutStageAction.delete,
            iconData: Icons.delete_outline,
            label: Str.of(context).delete,
          ),
        ],
      );

  Future<void> _editWorkoutStage() async {
    final bloc = context.read<WorkoutCreatorBloc>();
    final WorkoutStage? updatedWorkoutStage =
        await showDialogDependingOnScreenSize(
      WorkoutStageCreatorScreen(stage: widget.workoutStage),
    );
    if (updatedWorkoutStage != null) {
      bloc.add(
        WorkoutCreatorEventWorkoutStageUpdated(
          stageIndex: widget.index,
          workoutStage: updatedWorkoutStage,
        ),
      );
    }
  }

  void _deleteWorkoutStage() {
    context.read<WorkoutCreatorBloc>().add(
          WorkoutCreatorEventDeleteWorkoutStage(index: widget.index),
        );
  }
}

class _DragHandle extends StatelessWidget {
  final int itemIndex;

  const _DragHandle({
    required this.itemIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      index: itemIndex,
      child: const Icon(Icons.drag_handle),
    );
  }
}
