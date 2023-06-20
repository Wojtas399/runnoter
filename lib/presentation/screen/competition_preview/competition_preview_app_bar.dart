part of 'competition_preview_screen.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        Str.of(context).competitionPreviewScreenTitle,
      ),
      actions: const [
        _ActionsMenu(),
      ],
    );
  }
}

enum _Action { edit, delete }

class _ActionsMenu extends StatelessWidget {
  const _ActionsMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_Action>(
      icon: const Icon(Icons.more_vert),
      onSelected: (_Action action) {
        _manageActions(context, action);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<_Action>(
          value: _Action.edit,
          child: Row(
            children: [
              const Icon(Icons.edit_outlined),
              const SizedBox(width: 8),
              Text(
                Str.of(context).edit,
              )
            ],
          ),
        ),
        PopupMenuItem<_Action>(
          value: _Action.delete,
          child: Row(
            children: [
              const Icon(Icons.delete_outline),
              const SizedBox(width: 8),
              Text(
                Str.of(context).delete,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _manageActions(BuildContext context, _Action action) {
    switch (action) {
      case _Action.edit:
        _editTest(context);
        break;
      case _Action.delete:
        _deleteTest(context);
        break;
    }
  }

  void _editTest(BuildContext context) {
    final String? competitionId =
        context.read<CompetitionPreviewBloc>().state.competition?.id;
    if (competitionId != null) {
      navigateTo(
        context: context,
        route: CompetitionCreatorRoute(
          competitionId: competitionId,
        ),
      );
    }
  }

  Future<void> _deleteTest(BuildContext context) async {
    final CompetitionPreviewBloc bloc = context.read<CompetitionPreviewBloc>();
    final bool confirmed = await askForConfirmation(
      context: context,
      title: Str.of(context).competitionPreviewDeleteCompetitionTitle,
      message: Str.of(context).competitionPreviewDeleteCompetitionMessage,
      confirmButtonLabel: Str.of(context).delete,
    );
    if (confirmed == true) {
      bloc.add(
        const CompetitionPreviewEventDeleteCompetition(),
      );
    }
  }
}
