part of 'day_preview_screen.dart';

class _AppBar extends StatelessWidget with PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        Str.of(context).day_preview_screen_title,
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
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<int>(
          value: 0,
          onTap: () {
            _onEditButtonPressed(context);
          },
          child: Row(
            children: [
              const Icon(Icons.edit_outlined),
              const SizedBox(width: 8),
              Text(
                Str.of(context).day_preview_edit_workout_label,
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          onTap: () {
            _onDeleteButtonPressed(context);
          },
          child: Row(
            children: [
              const Icon(Icons.delete_outline),
              const SizedBox(width: 8),
              Text(
                Str.of(context).day_preview_delete_workout_label,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onEditButtonPressed(BuildContext context) {
    context.read<DayPreviewBloc>().add(
          const DayPreviewEventEditWorkout(),
        );
  }

  void _onDeleteButtonPressed(BuildContext context) {
    context.read<DayPreviewBloc>().add(
          const DayPreviewEventDeleteWorkout(),
        );
  }
}
