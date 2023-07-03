part of 'workout_stage_creator_screen.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const _Title(),
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

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = context.select(
      (WorkoutStageCreatorBloc bloc) => bloc.state.isEditMode,
    );
    return Text(
      isEditMode
          ? Str.of(context).workoutStageCreatorScreenTitleEditMode
          : Str.of(context).workoutStageCreatorScreenTitleAddMode,
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = context.select(
      (WorkoutStageCreatorBloc bloc) => bloc.state.isEditMode,
    );
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
        isEditMode ? Str.of(context).save : Str.of(context).add,
      ),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<WorkoutStageCreatorBloc>().add(
          const WorkoutStageCreatorEventSubmit(),
        );
  }
}
