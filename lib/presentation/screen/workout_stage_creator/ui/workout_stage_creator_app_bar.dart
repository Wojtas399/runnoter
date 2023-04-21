part of 'workout_stage_creator_screen.dart';

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
      actions: const [
        _SaveButton(),
        SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = context.select(
      (WorkoutStageCreatorBloc bloc) {
        final WorkoutStageCreatorState state = bloc.state;
        if (state is WorkoutStageCreatorStateInProgress) {
          return state.isAddButtonDisabled;
        }
        return false;
      },
    );

    return TextButton(
      onPressed: isButtonDisabled ? null : () {},
      child: Text(
        AppLocalizations.of(context)!.add,
      ),
    );
  }
}
