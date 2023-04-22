import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/workout_stage.dart';
import '../../../service/dialog_service.dart';
import '../../workout_stage_creator/ui/workout_stage_creator_screen.dart';
import '../bloc/workout_creator_bloc.dart';
import '../bloc/workout_creator_event.dart';
import 'workout_creator_workout_stage_item.dart';

class WorkoutCreatorWorkoutStages extends StatelessWidget {
  const WorkoutCreatorWorkoutStages({
    super.key,
  });

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
      style: Theme.of(context).textTheme.titleMedium,
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

    if (stages.isEmpty) {
      return const _NoWorkoutStagesInfo();
    }
    if (stages.length == 1) {
      return WorkoutCreatorWorkoutStageItem(
        index: 0,
        workoutStage: stages.first,
      );
    }
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
        for (int i = 0; i < stages.length; i++)
          WorkoutCreatorWorkoutStageItem(
            key: Key('$i'),
            index: i,
            workoutStage: stages[i],
          ),
      ],
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
