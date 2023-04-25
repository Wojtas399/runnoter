part of 'workout_creator_screen.dart';

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (WorkoutCreatorBloc bloc) => bloc.state.isSubmitButtonDisabled,
    );

    return CustomFilledButton(
      label: AppLocalizations.of(context)!
          .workout_creator_screen_add_workout_button_label,
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
