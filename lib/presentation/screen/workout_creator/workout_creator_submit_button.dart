part of 'workout_creator_screen.dart';

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final Workout? workout = context.select(
      (WorkoutCreatorBloc bloc) => bloc.state.workout,
    );
    final bool isDisabled = context.select(
      (WorkoutCreatorBloc bloc) => !bloc.state.canSubmit,
    );

    return BigButton(
      label: workout != null
          ? Str.of(context).workoutCreatorEditWorkoutButton
          : Str.of(context).workoutCreatorAddWorkoutButton,
      isDisabled: isDisabled,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    context.read<WorkoutCreatorBloc>().add(
          const WorkoutCreatorEventSubmit(),
        );
  }
}
