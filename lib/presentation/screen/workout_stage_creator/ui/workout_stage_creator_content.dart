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
      onChanged: (WorkoutStageType? stage) {
        _onWorkoutStageChanged(context, stage);
      },
    );
  }

  String _getWorkoutStageName(
    BuildContext context,
    WorkoutStageType stage,
  ) {
    final str = Str.of(context);
    switch (stage) {
      case WorkoutStageType.baseRun:
        return str.workoutStageBaseRun;
      case WorkoutStageType.zone2:
        return str.workoutStageZone2;
      case WorkoutStageType.zone3:
        return str.workoutStageZone3;
      case WorkoutStageType.hillRepeats:
        return str.workoutStageHillRepeats;
      case WorkoutStageType.rhythms:
        return str.workoutStageRhythms;
      case WorkoutStageType.stretching:
        return str.workoutStageStretching;
      case WorkoutStageType.strengthening:
        return str.workoutStageStrengthening;
      case WorkoutStageType.foamRolling:
        return str.workoutStageFoamRolling;
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
