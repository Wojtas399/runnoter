part of 'workout_creator_screen.dart';

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final Workout? workout = context.select(
      (WorkoutCreatorBloc bloc) => bloc.state.workout,
    );
    final bool isDisabled = context.select(
      (WorkoutCreatorBloc bloc) => bloc.state.isSubmitButtonDisabled,
    );

    return BigButton(
      label: workout != null
          ? Str.of(context).workout_creator_screen_edit_workout_button_label
          : Str.of(context).workout_creator_screen_add_workout_button_label,
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
