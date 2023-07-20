part of 'workout_preview_screen.dart';

class _WorkoutActions extends StatelessWidget {
  const _WorkoutActions();

  @override
  Widget build(BuildContext context) {
    return EditDeleteActions(
      displayAsPopupMenu: context.isMobileSize,
      onEditSelected: () => _editWorkout(context),
      onDeleteSelected: () => _deleteWorkout(context),
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
