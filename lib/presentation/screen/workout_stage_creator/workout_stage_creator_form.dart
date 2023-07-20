import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/workout_stage_creator/workout_stage_creator_bloc.dart';
import 'workout_stage_creator_distance_form.dart';
import 'workout_stage_creator_series_form.dart';

class WorkoutStageCreatorFormContent extends StatelessWidget {
  const WorkoutStageCreatorFormContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WorkoutStageType(),
        _MatchingForm(),
      ],
    );
  }
}

class _WorkoutStageType extends StatelessWidget {
  const _WorkoutStageType();

  @override
  Widget build(BuildContext context) {
    final WorkoutStageType? stageType = context.select(
      (WorkoutStageCreatorBloc bloc) => bloc.state.stageType,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: stageType != null ? 40 : 0),
      child: DropdownButtonFormField<WorkoutStageType>(
        value: stageType,
        decoration: InputDecoration(
          hintText: Str.of(context).workoutStageCreatorStageType,
        ),
        items: <DropdownMenuItem<WorkoutStageType>>[
          ...WorkoutStageType.values.map(
            (WorkoutStageType stage) => DropdownMenuItem(
              value: stage,
              child: Text(
                _getWorkoutStageName(context, stage),
              ),
            ),
          ),
        ],
        onChanged: (WorkoutStageType? stage) =>
            _onWorkoutStageChanged(context, stage),
      ),
    );
  }

  String _getWorkoutStageName(
    BuildContext context,
    WorkoutStageType stage,
  ) {
    final str = Str.of(context);
    switch (stage) {
      case WorkoutStageType.cardio:
        return str.workoutStageCardio;
      case WorkoutStageType.zone2:
        return str.workoutStageZone2;
      case WorkoutStageType.zone3:
        return str.workoutStageZone3;
      case WorkoutStageType.hillRepeats:
        return str.workoutStageHillRepeats;
      case WorkoutStageType.rhythms:
        return str.workoutStageRhythms;
    }
  }

  void _onWorkoutStageChanged(
    BuildContext context,
    WorkoutStageType? stageType,
  ) {
    if (stageType != null) {
      context.read<WorkoutStageCreatorBloc>().add(
            WorkoutStageCreatorEventStageTypeChanged(
              stageType: stageType,
            ),
          );
    }
  }
}

class _MatchingForm extends StatelessWidget {
  const _MatchingForm();

  @override
  Widget build(BuildContext context) {
    final bool isDistanceStage = context.select(
      (WorkoutStageCreatorBloc bloc) => bloc.state.isDistanceStage,
    );
    final bool isSeriesStage = context.select(
      (WorkoutStageCreatorBloc bloc) => bloc.state.isSeriesStage,
    );

    if (isDistanceStage) {
      return const WorkoutStageCreatorDistanceStageForm();
    } else if (isSeriesStage) {
      return const WorkoutStageCreatorSeriesStageForm();
    }
    return const SizedBox();
  }
}
