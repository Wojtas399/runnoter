part of 'workout_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool confirmationToLeave = await askForConfirmationToLeave(
          areUnsavedChanges: context.read<WorkoutCreatorBloc>().state.canSubmit,
        );
        if (confirmationToLeave) unfocusInputs();
        return confirmationToLeave;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const _AppBarTitle(),
          centerTitle: true,
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: unfocusInputs,
            child: ScreenAdjustableBody(
              child: Column(
                children: [
                  _WorkoutName(),
                  const SizedBox(height: 24),
                  const _WorkoutStagesSection(),
                  const SizedBox(height: 40),
                  const _SubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    final Workout? workout = context.select(
      (WorkoutCreatorBloc bloc) => bloc.state.workout,
    );
    String title = Str.of(context).workoutCreatorScreenNewWorkoutTitle;
    if (workout != null) {
      title = Str.of(context).workoutCreatorScreeEditWorkoutTitle;
    }
    return Text(title);
  }
}

class _WorkoutName extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  _WorkoutName();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (WorkoutCreatorBloc bloc) => bloc.state.status,
    );
    final String? workoutName = context.select(
      (WorkoutCreatorBloc bloc) => bloc.state.workoutName,
    );
    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == WorkoutCreatorBlocInfo.editModeInitialized) {
      _controller.text = workoutName ?? '';
    }

    return TextFieldComponent(
      label: Str.of(context).workoutCreatorWorkoutName,
      isRequired: true,
      controller: _controller,
      maxLength: 100,
      onChanged: (String? workoutName) {
        _onChanged(context, workoutName);
      },
    );
  }

  void _onChanged(BuildContext context, String? workoutName) {
    context.read<WorkoutCreatorBloc>().add(
          WorkoutCreatorEventWorkoutNameChanged(
            workoutName: workoutName,
          ),
        );
  }
}
