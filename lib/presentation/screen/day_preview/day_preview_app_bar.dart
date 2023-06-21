part of 'day_preview_screen.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        Str.of(context).dayPreviewScreenTitle,
      ),
      centerTitle: true,
      actions: const [
        _AppBarActions(),
      ],
    );
  }
}

class _AppBarActions extends StatelessWidget {
  const _AppBarActions();

  @override
  Widget build(BuildContext context) {
    final String? workoutId = context.select(
      (DayPreviewBloc bloc) => bloc.state.workoutId,
    );

    if (workoutId == null) {
      return const SizedBox(height: 16);
    }
    return const _WorkoutActions();
  }
}

class _WorkoutActions extends StatelessWidget {
  const _WorkoutActions();

  @override
  Widget build(BuildContext context) {
    return EditDeletePopupMenu(
      editLabel: Str.of(context).dayPreviewEditWorkout,
      deleteLabel: Str.of(context).dayPreviewDeleteWorkout,
      onEditSelected: () {
        _onEditSelected(context);
      },
      onDeleteSelected: () {
        _onDeleteSelected(context);
      },
    );
  }

  void _onEditSelected(BuildContext context) {
    final DayPreviewBloc dayPreviewBloc = context.read<DayPreviewBloc>();
    final DateTime? date = dayPreviewBloc.state.date;
    final String? workoutId = dayPreviewBloc.state.workoutId;
    if (date != null && workoutId != null) {
      navigateTo(
        context: context,
        route: WorkoutCreatorRoute(
          creatorArguments: WorkoutCreatorEditModeArguments(
            date: date,
            workoutId: workoutId,
          ),
        ),
      );
    }
  }

  void _onDeleteSelected(BuildContext context) {
    context.read<DayPreviewBloc>().add(
          const DayPreviewEventDeleteWorkout(),
        );
  }
}
