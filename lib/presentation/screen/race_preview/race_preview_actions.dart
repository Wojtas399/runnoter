import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/race_preview/race_preview_bloc.dart';
import '../../component/edit_delete_popup_menu_component.dart';
import '../../config/navigation/router.dart';
import '../../extension/context_extensions.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';

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
    final String? raceId = context.read<RacePreviewBloc>().state.race?.id;
    if (raceId != null) {
      navigateTo(
        RaceCreatorRoute(raceId: raceId),
      );
    }
  }

  Future<void> _deleteRace(BuildContext context) async {
    final RacePreviewBloc bloc = context.read<RacePreviewBloc>();
    final str = Str.of(context);
    final bool confirmed = await askForConfirmation(
      title: Text(str.racePreviewDeletionConfirmationTitle),
      content: Text(str.racePreviewDeletionConfirmationMessage),
      confirmButtonLabel: str.delete,
      confirmButtonColor: Theme.of(context).colorScheme.error,
    );
    if (confirmed == true) {
      bloc.add(const RacePreviewEventDeleteRace());
    }
  }
}
