import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/workout_creator/workout_creator_bloc.dart';
import '../../../domain/entity/workout_stage.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/label_text_components.dart';
import '../../dialog/workout_stage_creator/workout_stage_creator_dialog.dart';
import '../../service/dialog_service.dart';
import '../../service/utils.dart';
import 'workout_creator_workout_stage_item.dart';

class WorkoutCreatorWorkoutStages extends StatelessWidget {
  const WorkoutCreatorWorkoutStages({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelLarge(Str.of(context).workoutCreatorWorkoutStages),
          const SizedBox(height: 8),
          const _WorkoutStagesList(),
          const SizedBox(height: 16),
          const _AddStageButton()
        ],
      ),
    );
  }
}

class _WorkoutStagesList extends StatelessWidget {
  const _WorkoutStagesList();

  @override
  Widget build(BuildContext context) {
    final List<WorkoutStage> stages = context.select(
      (WorkoutCreatorBloc bloc) => bloc.state.stages,
    );

    if (stages.isEmpty) return const _NoWorkoutStagesInfo();
    if (stages.length == 1) {
      return WorkoutCreatorWorkoutStageItem(
        index: 0,
        workoutStage: stages.first,
      );
    }
    return _ReorderableWorkoutStages(workoutStages: stages);
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
          BodyLarge(Str.of(context).workoutCreatorNoStagesInfo),
          const SizedBox(height: 4),
          BodyMedium(Str.of(context).workoutCreatorAddStageInstructions),
        ],
      ),
    );
  }
}

class _ReorderableWorkoutStages extends StatefulWidget {
  final List<WorkoutStage> workoutStages;

  const _ReorderableWorkoutStages({
    required this.workoutStages,
  });

  @override
  State<StatefulWidget> createState() => _ReorderableWorkoutStagesState();
}

class _ReorderableWorkoutStagesState extends State<_ReorderableWorkoutStages> {
  List<WorkoutStage> _stages = [];

  @override
  void initState() {
    _stages = widget.workoutStages;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _ReorderableWorkoutStages oldWidget) {
    _stages = widget.workoutStages;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      proxyDecorator: (Widget child, _, Animation<double> animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) => Material(
            elevation: 10,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            child: child,
          ),
          child: child,
        );
      },
      onReorder: (int oldIndex, int newIndex) => _onReorder(oldIndex, newIndex),
      itemCount: _stages.length,
      itemBuilder: (_, int itemIndex) => WorkoutCreatorWorkoutStageItem(
        key: Key('$itemIndex'),
        index: itemIndex,
        workoutStage: _stages[itemIndex],
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) newIndex -= 1;
      final WorkoutStage stage = _stages.removeAt(oldIndex);
      _stages.insert(newIndex, stage);
    });
    context.read<WorkoutCreatorBloc>().add(
          WorkoutCreatorEventWorkoutStagesOrderChanged(workoutStages: _stages),
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
            Str.of(context).workoutCreatorAddStageButton,
          ),
        ),
      ],
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    unfocusInputs();
    final WorkoutCreatorBloc bloc = context.read<WorkoutCreatorBloc>();
    final WorkoutStage? workoutStage = await showDialogDependingOnScreenSize(
      const WorkoutStageCreatorDialog(),
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
