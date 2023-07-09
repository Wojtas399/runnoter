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
    final dayPreviewBloc = context.read<WorkoutPreviewBloc>();
    final DateTime? date = dayPreviewBloc.state.date;
    if (date != null) {
      navigateTo(
        context: context,
        route: WorkoutCreatorRoute(
          creatorArguments: WorkoutCreatorEditModeArguments(
            date: date,
            workoutId: dayPreviewBloc.workoutId,
          ),
        ),
      );
    }
  }

  void _deleteWorkout(BuildContext context) {
    context.read<WorkoutPreviewBloc>().add(
          const WorkoutPreviewEventDeleteWorkout(),
        );
  }
}
