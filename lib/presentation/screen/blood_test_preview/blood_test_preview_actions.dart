part of 'blood_test_preview_screen.dart';

class _BloodTestActions extends StatelessWidget {
  const _BloodTestActions();

  @override
  Widget build(BuildContext context) {
    if (context.isMobileSize) {
      return EditDeletePopupMenu(
        onEditSelected: () {
          _editTest(context);
        },
        onDeleteSelected: () {
          _deleteTest(context);
        },
      );
    }
    final theme = Theme.of(context);
    return Row(
      children: [
        IconButton(
          onPressed: () => _editTest(context),
          icon: Icon(
            Icons.edit_outlined,
            color: theme.colorScheme.primary,
          ),
        ),
        IconButton(
          onPressed: () => _deleteTest(context),
          icon: Icon(
            Icons.delete_outline,
            color: theme.colorScheme.error,
          ),
        ),
      ],
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
