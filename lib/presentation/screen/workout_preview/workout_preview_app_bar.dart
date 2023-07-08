part of 'workout_preview_screen.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(Str.of(context).workoutPreviewScreenTitle),
      centerTitle: true,
      actions: context.isMobileSize ? const [_WorkoutActions()] : null,
    );
  }
}

class _WorkoutActions extends StatelessWidget {
  const _WorkoutActions();

  @override
  Widget build(BuildContext context) {
    if (context.isMobileSize) {
      return EditDeletePopupMenu(
        onEditSelected: () {
          _onEditSelected(context);
        },
        onDeleteSelected: () {
          _onDeleteSelected(context);
        },
      );
    }
    return Row(
      children: [
        IconButton(
          onPressed: () => _onEditSelected(context),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          onPressed: () => _onDeleteSelected(context),
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }

  void _onEditSelected(BuildContext context) {
    final WorkoutPreviewBloc dayPreviewBloc =
        context.read<WorkoutPreviewBloc>();
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

  void _onDeleteSelected(BuildContext context) {
    context.read<WorkoutPreviewBloc>().add(
          const WorkoutPreviewEventDeleteWorkout(),
        );
  }
}
