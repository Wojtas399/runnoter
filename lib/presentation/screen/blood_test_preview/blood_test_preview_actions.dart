import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/blood_test_preview/blood_test_preview_bloc.dart';
import '../../component/edit_delete_popup_menu_component.dart';
import '../../config/navigation/router.dart';
import '../../extension/context_extensions.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';

class BloodTestPreviewActions extends StatelessWidget {
  const BloodTestPreviewActions({super.key});

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
    final bloodTestPreviewBloc = context.read<BloodTestPreviewBloc>();
    navigateTo(BloodTestCreatorRoute(
      userId: bloodTestPreviewBloc.userId,
      bloodTestId: bloodTestPreviewBloc.bloodTestId,
    ));
  }

  Future<void> _deleteTest(BuildContext context) async {
    final BloodTestPreviewBloc bloc = context.read<BloodTestPreviewBloc>();
    final str = Str.of(context);
    final bool confirmed = await askForConfirmation(
      title: Text(str.bloodTestPreviewDeleteTestTitle),
      content: Text(str.bloodTestPreviewDeleteTestMessage),
      confirmButtonLabel: str.delete,
      confirmButtonColor: Theme.of(context).colorScheme.error,
    );
    if (confirmed == true) {
      bloc.add(
        const BloodTestPreviewEventDeleteTest(),
      );
    }
  }
}
