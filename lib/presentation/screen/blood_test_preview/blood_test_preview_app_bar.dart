part of 'blood_test_preview_screen.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      centerTitle: true,
      title: Text(
        Str.of(context).bloodTestPreviewScreenTitle,
      ),
      actions: const [
        _BloodTestActionsMenu(),
      ],
    );
  }
}

enum _BloodTestAction { edit, delete }

class _BloodTestActionsMenu extends StatelessWidget {
  const _BloodTestActionsMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_BloodTestAction>(
      icon: const Icon(Icons.more_vert),
      onSelected: (_BloodTestAction action) {
        _manageActions(context, action);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<_BloodTestAction>(
          value: _BloodTestAction.edit,
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
        PopupMenuItem<_BloodTestAction>(
          value: _BloodTestAction.delete,
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

  void _manageActions(BuildContext context, _BloodTestAction action) {
    switch (action) {
      case _BloodTestAction.edit:
        _editTest(context);
        break;
      case _BloodTestAction.delete:
        _deleteTest(context);
        break;
    }
  }

  void _editTest(BuildContext context) {
    final String? bloodTestId =
        context.read<BloodTestPreviewBloc>().state.bloodTestId;
    if (bloodTestId != null) {
      navigateTo(
        context: context,
        route: BloodTestCreatorRoute(
          bloodTestId: bloodTestId,
        ),
      );
    }
  }

  Future<void> _deleteTest(BuildContext context) async {
    final BloodTestPreviewBloc bloc = context.read<BloodTestPreviewBloc>();
    final bool confirmed = await askForConfirmation(
      context: context,
      title: Str.of(context).bloodTestPreviewDeleteTestTitle,
      message: Str.of(context).bloodTestPreviewDeleteTestMessage,
      confirmButtonLabel: Str.of(context).delete,
    );
    if (confirmed == true) {
      bloc.add(
        const BloodTestPreviewEventDeleteTest(),
      );
    }
  }
}
