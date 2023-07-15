part of 'blood_test_preview_screen.dart';

class _BloodTestActions extends StatelessWidget {
  const _BloodTestActions();

  @override
  Widget build(BuildContext context) {
    return EditDeleteActions(
      displayAsPopupMenu: context.isMobileSize,
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
        context.read<BloodTestPreviewBloc>().bloodTestId;
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
