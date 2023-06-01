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
        _BloodTestActions(),
      ],
    );
  }
}

class _BloodTestActions extends StatelessWidget {
  const _BloodTestActions();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<int>(
          value: 0,
          onTap: () {
            _onEditActionPressed(context);
          },
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
        PopupMenuItem<int>(
          value: 1,
          onTap: () {
            _onDeleteActionPressed(context);
          },
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

  void _onEditActionPressed(BuildContext context) {
    //TODO
  }

  Future<void> _onDeleteActionPressed(BuildContext context) async {
    final BloodTestPreviewBloc bloc = context.read<BloodTestPreviewBloc>();
    final bool confirmed = await askForConfirmation(
      context: context,
      title: Str.of(context).bloodTestPreviewDeleteTestTitle,
      message: Str.of(context).bloodTestPreviewDeleteTestMessage,
      confirmButtonLabel: Str.of(context).delete,
    );
    if (confirmed == true) {
      //TODO
    }
  }
}
