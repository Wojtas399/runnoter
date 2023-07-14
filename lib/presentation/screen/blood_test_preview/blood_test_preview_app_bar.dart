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
        Str.of(context).bloodTestPreviewTitle,
      ),
      actions: const [
        _BloodTestActionsMenu(),
      ],
    );
  }
}

class _BloodTestActionsMenu extends StatelessWidget {
  const _BloodTestActionsMenu();

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
    final String? bloodTestId =
        context.read<BloodTestPreviewBloc>().state.bloodTestId;
    if (bloodTestId != null) {
      navigateTo(
        BloodTestCreatorRoute(bloodTestId: bloodTestId),
      );
    }
  }

  Future<void> _deleteTest(BuildContext context) async {
    final BloodTestPreviewBloc bloc = context.read<BloodTestPreviewBloc>();
    final str = Str.of(context);
    final bool confirmed = await askForConfirmation(
      title: str.bloodTestPreviewDeleteTestTitle,
      message: str.bloodTestPreviewDeleteTestMessage,
      confirmButtonLabel: str.delete,
    );
    if (confirmed == true) {
      bloc.add(
        const BloodTestPreviewEventDeleteTest(),
      );
    }
  }
}
