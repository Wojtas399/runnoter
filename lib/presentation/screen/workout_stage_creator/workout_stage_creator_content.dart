part of 'workout_stage_creator_screen.dart';

class _FullScreenDialogContent extends StatelessWidget {
  const _FullScreenDialogContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: unfocusInputs,
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(24),
            child: const _Form(),
          ),
        ),
      ),
    );
  }
}

class _NormalDialogContent extends StatelessWidget {
  const _NormalDialogContent();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const _DialogTitle(),
      content: const SizedBox(
        width: 500,
        child: _Form(),
      ),
      actions: [
        TextButton(
          onPressed: () => navigateBack(context: context),
          child: Text(Str.of(context).cancel),
        ),
        const _SaveButton(),
      ],
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const _DialogTitle(),
      leading: IconButton(
        onPressed: () => navigateBack(context: context),
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

class _DialogTitle extends StatelessWidget {
  const _DialogTitle();

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
    final Widget label = Text(
      isEditMode ? Str.of(context).save : Str.of(context).add,
    );

    if (context.isMobileSize) {
      return FilledButton(
        onPressed: isButtonDisabled ? null : () => _onPressed(context),
        child: label,
      );
    }
    return TextButton(
      onPressed: isButtonDisabled ? null : () => _onPressed(context),
      child: label,
    );
  }

  void _onPressed(BuildContext context) {
    context.read<WorkoutStageCreatorBloc>().add(
          const WorkoutStageCreatorEventSubmit(),
        );
  }
}
