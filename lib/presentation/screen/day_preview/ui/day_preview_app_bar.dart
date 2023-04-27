part of 'day_preview_screen.dart';

class _AppBar extends StatelessWidget with PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context)!.day_preview_screen_title,
      ),
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (_) => [
            PopupMenuItem<int>(
              value: 0,
              child: Row(
                children: [
                  const Icon(Icons.edit_outlined),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!
                        .day_preview_screen_edit_workout_label,
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
                    AppLocalizations.of(context)!
                        .day_preview_screen_delete_workout_label,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onDeleteButtonPressed(BuildContext context) {
    context.read<DayPreviewBloc>().add(
          const DayPreviewEventDeleteWorkout(),
        );
  }
}
