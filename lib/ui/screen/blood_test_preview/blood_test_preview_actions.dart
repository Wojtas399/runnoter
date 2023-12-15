import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../component/edit_delete_popup_menu_component.dart';
import '../../config/navigation/router.dart';
import '../../cubit/blood_test_preview/blood_test_preview_cubit.dart';
import '../../extension/context_extensions.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';

class BloodTestPreviewActions extends StatelessWidget {
  const BloodTestPreviewActions({super.key});

  @override
  Widget build(BuildContext context) {
    return EditDeleteActions(
      displayAsPopupMenu: context.isMobileSize,
      onEditSelected: () => _editTest(context),
      onDeleteSelected: () => _deleteTest(context),
    );
  }

  void _editTest(BuildContext context) {
    final bloodTestPreviewCubit = context.read<BloodTestPreviewCubit>();
    navigateTo(BloodTestCreatorRoute(
      userId: bloodTestPreviewCubit.userId,
      bloodTestId: bloodTestPreviewCubit.bloodTestId,
    ));
  }

  Future<void> _deleteTest(BuildContext context) async {
    final BloodTestPreviewCubit cubit = context.read<BloodTestPreviewCubit>();
    final str = Str.of(context);
    final bool isDeletionConfirmed =
        await _askForTestDeletionConfirmation(context);
    if (isDeletionConfirmed == true) {
      showLoadingDialog();
      await cubit.deleteTest();
      closeLoadingDialog();
      if (context.mounted) {
        context.router.popUntil((route) {
          final String? routeName = route.settings.name;
          return routeName == HomeRoute.name || routeName == ClientRoute.name;
        });
      }
      showSnackbarMessage(str.bloodTestPreviewDeletedTestMessage);
    }
  }

  Future<bool> _askForTestDeletionConfirmation(BuildContext context) async {
    final str = Str.of(context);
    return await askForConfirmation(
      title: Text(str.bloodTestPreviewDeleteTestTitle),
      content: Text(str.bloodTestPreviewDeleteTestMessage),
      confirmButtonLabel: str.delete,
      confirmButtonColor: Theme.of(context).colorScheme.error,
    );
  }
}
