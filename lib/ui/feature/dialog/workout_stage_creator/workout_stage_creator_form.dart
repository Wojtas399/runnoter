import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'cubit/workout_stage_creator_cubit.dart';
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
      (WorkoutStageCreatorCubit cubit) => cubit.state.stageType,
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
        onChanged: context.read<WorkoutStageCreatorCubit>().stageTypeChanged,
      ),
    );
  }

  String _getWorkoutStageName(
    BuildContext context,
    WorkoutStageType stage,
  ) {
    final str = Str.of(context);
    return switch (stage) {
      WorkoutStageType.cardio => str.workoutStageCardio,
      WorkoutStageType.zone2 => str.workoutStageZone2,
      WorkoutStageType.zone3 => str.workoutStageZone3,
      WorkoutStageType.hillRepeats => str.workoutStageHillRepeats,
      WorkoutStageType.rhythms => str.workoutStageRhythms,
    };
  }
}

class _MatchingForm extends StatelessWidget {
  const _MatchingForm();

  @override
  Widget build(BuildContext context) {
    final bool isDistanceStage = context.select(
      (WorkoutStageCreatorCubit cubit) => cubit.state.isDistanceStage,
    );
    final bool isSeriesStage = context.select(
      (WorkoutStageCreatorCubit cubit) => cubit.state.isSeriesStage,
    );

    if (isDistanceStage) {
      return const WorkoutStageCreatorDistanceStageForm();
    } else if (isSeriesStage) {
      return const WorkoutStageCreatorSeriesStageForm();
    }
    return const SizedBox();
  }
}
