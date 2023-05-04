part of 'workout_status_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.workout_status_creator_screen_title,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ScrollableContent(
          child: GestureDetector(
            onTap: () {
              unfocusInputs();
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: const [
                  _StatusType(),
                  SizedBox(height: 24),
                  _Form(),
                  SizedBox(height: 24),
                  _SubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    final WorkoutStatusType? workoutStatusType = context.select(
      (WorkoutStatusCreatorBloc bloc) => bloc.state.workoutStatusType,
    );

    if (workoutStatusType == WorkoutStatusType.completed ||
        workoutStatusType == WorkoutStatusType.uncompleted) {
      return const _FinishedWorkoutForm();
    }
    return const SizedBox();
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isFormValid = context.select(
      (WorkoutStatusCreatorBloc bloc) => bloc.state.isFormValid,
    );
    final bool areDataSameAsOriginal = context.select(
      (WorkoutStatusCreatorBloc bloc) => bloc.state.areDataSameAsOriginal,
    );

    return BigButton(
      label: AppLocalizations.of(context)!.save,
      isDisabled: !isFormValid || areDataSameAsOriginal,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    context.read<WorkoutStatusCreatorBloc>().add(
          const WorkoutStatusCreatorEventSubmit(),
        );
  }
}
