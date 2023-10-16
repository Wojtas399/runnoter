import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/edit_delete_popup_menu_component.dart';
import '../../../config/navigation/router.dart';
import '../../../cubit/race_preview/race_preview_cubit.dart';
import '../../../extension/context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';

class RacePreviewActions extends StatelessWidget {
  const RacePreviewActions({super.key});

  @override
  Widget build(BuildContext context) {
    return EditDeleteActions(
      displayAsPopupMenu: context.isMobileSize,
      onEditSelected: () => _editRace(context),
      onDeleteSelected: () => _deleteRace(context),
    );
  }

  void _editRace(BuildContext context) {
    final RacePreviewCubit cubit = context.read<RacePreviewCubit>();
    navigateTo(RaceCreatorRoute(
      userId: cubit.userId,
      raceId: cubit.raceId,
    ));
  }

  Future<void> _deleteRace(BuildContext context) async {
    final RacePreviewCubit cubit = context.read<RacePreviewCubit>();
    final str = Str.of(context);
    final bool confirmed = await _askForRaceDeletionConfirmation(context);
    if (confirmed == true) {
      showLoadingDialog();
      await cubit.deleteRace();
      closeLoadingDialog();
      navigateBack();
      showSnackbarMessage(str.racePreviewDeletedRaceMessage);
    }
  }

  Future<bool> _askForRaceDeletionConfirmation(BuildContext context) async {
    final str = Str.of(context);
    return await askForConfirmation(
      title: Text(str.racePreviewDeletionConfirmationTitle),
      content: Text(str.racePreviewDeletionConfirmationMessage),
      confirmButtonLabel: str.delete,
      confirmButtonColor: Theme.of(context).colorScheme.error,
    );
  }
}
