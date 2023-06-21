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
