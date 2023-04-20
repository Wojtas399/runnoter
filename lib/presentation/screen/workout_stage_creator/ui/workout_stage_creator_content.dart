import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../service/navigator_service.dart';
import '../../../service/utils.dart';
import '../bloc/workout_stage_creator_bloc.dart';
import '../bloc/workout_stage_creator_event.dart';
import '../bloc/workout_stage_creator_state.dart';

class WorkoutStageCreatorContent extends StatelessWidget {
  const WorkoutStageCreatorContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            unfocusInputs();
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: const [
                _WorkoutStageType(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget with PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context)!.workout_stage_creator_screen_title,
      ),
      leading: IconButton(
        onPressed: () {
          navigateBack(context: context);
        },
        icon: const Icon(Icons.close),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text(
            AppLocalizations.of(context)!.save,
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _WorkoutStageType extends StatelessWidget {
  const _WorkoutStageType();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        filled: true,
        hintText: AppLocalizations.of(context)!
            .workout_stage_creator_screen_stage_type,
      ),
      items: <DropdownMenuItem<WorkoutStage>>[
        ...WorkoutStage.values.map(
          (WorkoutStage stage) => DropdownMenuItem(
            value: stage,
            child: Text(
              _getWorkoutStageName(context, stage),
            ),
          ),
        ),
      ],
      onChanged: (WorkoutStage? stage) {
        _onWorkoutStageChanged(context, stage);
      },
    );
  }

  String _getWorkoutStageName(BuildContext context, WorkoutStage stage) {
    final appLocalizations = AppLocalizations.of(context);
    switch (stage) {
      case WorkoutStage.cardio:
        return appLocalizations!.workout_cardio;
      case WorkoutStage.zone2:
        return appLocalizations!.workout_zone2;
      case WorkoutStage.zone3:
        return appLocalizations!.workout_zone3;
      case WorkoutStage.strength:
        return appLocalizations!.workout_strength;
      case WorkoutStage.rhythms:
        return appLocalizations!.workout_rhythms;
      case WorkoutStage.stretching:
        return appLocalizations!.workout_stretching;
      case WorkoutStage.strengthening:
        return appLocalizations!.workout_strengthening;
      case WorkoutStage.foamRolling:
        return appLocalizations!.workout_foamRolling;
    }
  }

  void _onWorkoutStageChanged(BuildContext context, WorkoutStage? stage) {
    if (stage != null) {
      context.read<WorkoutStageCreatorBloc>().add(
            WorkoutStageCreatorEventStageTypeChanged(stage: stage),
          );
    }
  }
}
