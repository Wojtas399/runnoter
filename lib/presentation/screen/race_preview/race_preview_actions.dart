part of 'race_preview_screen.dart';

class _RaceActions extends StatelessWidget {
  const _RaceActions();

  @override
  Widget build(BuildContext context) {
    if (context.isMobileSize) {
      return EditDeletePopupMenu(
        onEditSelected: () => _editRace(context),
        onDeleteSelected: () => _deleteRace(context),
      );
    }
    return Row(
      children: [
        IconButton(
          onPressed: () => _editRace(context),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          onPressed: () => _deleteRace(context),
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }

  void _editRace(BuildContext context) {
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

  Future<void> _deleteRace(BuildContext context) async {
    final RacePreviewBloc bloc = context.read<RacePreviewBloc>();
    final str = Str.of(context);
    final bool confirmed = await askForConfirmation(
      context: context,
      title: str.racePreviewDeleteRaceTitle,
      message: str.racePreviewDeleteRaceMessage,
      confirmButtonLabel: str.delete,
      cancelButtonColor: Theme.of(context).colorScheme.error,
    );
    if (confirmed == true) {
      bloc.add(
        const RacePreviewEventDeleteRace(),
      );
    }
  }
}
