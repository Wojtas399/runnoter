part of 'workout_preview_screen.dart';

class _WorkoutActions extends StatelessWidget {
  const _WorkoutActions();

  @override
  Widget build(BuildContext context) {
    if (context.isMobileSize) {
      return EditDeletePopupMenu(
        onEditSelected: () => _editWorkout(context),
        onDeleteSelected: () => _deleteWorkout(context),
      );
    }
    return Row(
      children: [
        IconButton(
          onPressed: () => _editWorkout(context),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          onPressed: () => _deleteWorkout(context),
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }

  void _editWorkout(BuildContext context) {
    final WorkoutPreviewBloc bloc = context.read<WorkoutPreviewBloc>();
    final DateTime? date = bloc.state.date;
    if (date != null) {
      navigateTo(
        context: context,
        route: WorkoutCreatorRoute(
          creatorArguments: WorkoutCreatorEditModeArguments(
            date: date,
            workoutId: bloc.workoutId,
          ),
        ),
      );
    }
  }

  Future<void> _deleteWorkout(BuildContext context) async {
    final WorkoutPreviewBloc bloc = context.read<WorkoutPreviewBloc>();
    final str = Str.of(context);
    final bool confirmed = await askForConfirmation(
      context: context,
      title: str.workoutPreviewDeletionConfirmationTitle,
      message: str.workoutPreviewDeletionConfirmationMessage,
      confirmButtonLabel: str.delete,
      cancelButtonColor: Theme.of(context).colorScheme.error,
    );
    if (confirmed == true) {
      bloc.add(const WorkoutPreviewEventDeleteWorkout());
    }
  }
}
