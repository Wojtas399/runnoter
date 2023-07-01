part of 'workout_stage_creator_screen.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        Str.of(context).workoutStageCreatorScreenTitle,
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
      (WorkoutStageCreatorBloc bloc) => bloc.state.isSubmitButtonDisabled,
    );

    return FilledButton(
      onPressed: isButtonDisabled
          ? null
          : () {
              _onPressed(context);
            },
      child: Text(
        Str.of(context).add,
      ),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<WorkoutStageCreatorBloc>().add(
          const WorkoutStageCreatorEventSubmit(),
        );
  }
}
