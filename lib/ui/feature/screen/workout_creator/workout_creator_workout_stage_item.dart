import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/entity/workout.dart';
import '../../../component/edit_delete_popup_menu_component.dart';
import '../../../component/text/body_text_components.dart';
import '../../../cubit/workout_creator/workout_creator_cubit.dart';
import '../../../extension/context_extensions.dart';
import '../../../feature/dialog/workout_stage_creator/workout_stage_creator_dialog.dart';
import '../../../formatter/workout_stage_formatter.dart';
import '../../../service/dialog_service.dart';

class WorkoutCreatorWorkoutStageItem extends StatefulWidget {
  final int index;
  final WorkoutStage workoutStage;

  const WorkoutCreatorWorkoutStageItem({
    super.key,
    required this.index,
    required this.workoutStage,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<WorkoutCreatorWorkoutStageItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ReorderableDelayedDragStartListener(
          index: widget.index,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BodyMedium(widget.workoutStage.toUIFormat(context)),
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

  const _WorkoutStageActions({required this.stageIndex, required this.stage});

  @override
  Widget build(BuildContext context) {
    return EditDeleteActions(
      displayAsPopupMenu: context.isMobileSize,
      onEditSelected: () => _editWorkoutStage(context),
      onDeleteSelected: () => context
          .read<WorkoutCreatorCubit>()
          .deleteWorkoutStageAtIndex(stageIndex),
    );
  }

  Future<void> _editWorkoutStage(BuildContext context) async {
    final cubit = context.read<WorkoutCreatorCubit>();
    final WorkoutStage? updatedWorkoutStage =
        await showDialogDependingOnScreenSize(
      WorkoutStageCreatorDialog(stage: stage),
    );
    if (updatedWorkoutStage != null) {
      cubit.updateWorkoutStageAtIndex(
        stageIndex: stageIndex,
        updatedStage: updatedWorkoutStage,
      );
    }
  }
}
