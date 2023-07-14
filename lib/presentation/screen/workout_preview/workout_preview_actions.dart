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
    final theme = Theme.of(context);
    return Row(
      children: [
        IconButton(
          onPressed: () => _editWorkout(context),
          icon: Icon(
            Icons.edit_outlined,
            color: theme.colorScheme.primary,
          ),
        ),
        IconButton(
          onPressed: () => _deleteWorkout(context),
          icon: Icon(
            Icons.delete_outline,
            color: theme.colorScheme.error,
          ),
        ),
      ],
    );
  }

  void _editWorkout(BuildContext context) {
    final WorkoutPreviewBloc bloc = context.read<WorkoutPreviewBloc>();
    final DateTime? date = bloc.state.date;
    final String? workoutId = bloc.workoutId;
    if (date != null && workoutId != null) {
      navigateTo(
        WorkoutCreatorRoute(
          date: date.toPathFormat(),
          workoutId: workoutId,
        ),
      );
    }
  }

  Future<void> _deleteWorkout(BuildContext context) async {
    final WorkoutPreviewBloc bloc = context.read<WorkoutPreviewBloc>();
    final str = Str.of(context);
    final bool confirmed = await askForConfirmation(
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
