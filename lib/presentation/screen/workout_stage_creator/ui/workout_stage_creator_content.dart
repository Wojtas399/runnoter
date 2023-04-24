part of 'workout_stage_creator_screen.dart';

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
                SizedBox(height: 40),
                _Form(),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
      onChanged: (WorkoutStageType? stage) {
        _onWorkoutStageChanged(context, stage);
      },
    );
  }

  String _getWorkoutStageName(
    BuildContext context,
    WorkoutStageType stage,
  ) {
    final appLocalizations = AppLocalizations.of(context);
    switch (stage) {
      case WorkoutStageType.baseRun:
        return appLocalizations!.workout_base_run;
      case WorkoutStageType.zone2:
        return appLocalizations!.workout_zone2;
      case WorkoutStageType.zone3:
        return appLocalizations!.workout_zone3;
      case WorkoutStageType.hillRepeats:
        return appLocalizations!.workout_hill_repeats;
      case WorkoutStageType.rhythms:
        return appLocalizations!.workout_rhythms;
      case WorkoutStageType.stretching:
        return appLocalizations!.workout_stretching;
      case WorkoutStageType.strengthening:
        return appLocalizations!.workout_strengthening;
      case WorkoutStageType.foamRolling:
        return appLocalizations!.workout_foamRolling;
    }
  }

  void _onWorkoutStageChanged(
      BuildContext context, WorkoutStageType? stageType) {
    if (stageType != null) {
      context.read<WorkoutStageCreatorBloc>().add(
            WorkoutStageCreatorEventStageTypeChanged(
              stageType: stageType,
            ),
          );
    }
  }
}

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    final WorkoutStageCreatorForm? form = context.select(
      (WorkoutStageCreatorBloc bloc) {
        final WorkoutStageCreatorState state = bloc.state;
        if (state is WorkoutStageCreatorStateInProgress) {
          return state.form;
        }
        return null;
      },
    );

    if (form is WorkoutStageCreatorDistanceStageForm) {
      return const _DistanceStageForm();
    } else if (form is WorkoutStageCreatorSeriesStageForm) {
      return const _SeriesStageForm();
    }
    return const SizedBox();
  }
}
