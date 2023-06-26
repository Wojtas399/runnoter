part of 'race_preview_screen.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        Str.of(context).racePreviewScreenTitle,
      ),
      actions: const [
        _ActionsMenu(),
      ],
    );
  }
}

class _ActionsMenu extends StatelessWidget {
  const _ActionsMenu();

  @override
  Widget build(BuildContext context) {
    return EditDeletePopupMenu(
      onEditSelected: () {
        _editTest(context);
      },
      onDeleteSelected: () {
        _deleteTest(context);
      },
    );
  }

  void _editTest(BuildContext context) {
    final String? raceId = context.read<RacePreviewBloc>().state.race?.id;
    if (raceId != null) {
      navigateTo(
        context: context,
        route: RaceCreatorRoute(
          arguments: RaceCreatorArguments(raceId: raceId),
        ),
      );
    }
  }

  Future<void> _deleteTest(BuildContext context) async {
    final RacePreviewBloc bloc = context.read<RacePreviewBloc>();
    final bool confirmed = await askForConfirmation(
      context: context,
      title: Str.of(context).racePreviewDeleteRaceTitle,
      message: Str.of(context).racePreviewDeleteRaceMessage,
      confirmButtonLabel: Str.of(context).delete,
    );
    if (confirmed == true) {
      bloc.add(
        const RacePreviewEventDeleteRace(),
      );
    }
  }
}
