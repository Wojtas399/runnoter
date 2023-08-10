import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/workout_preview/workout_preview_bloc.dart';
import '../../component/edit_delete_popup_menu_component.dart';
import '../../config/navigation/router.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';

class WorkoutPreviewWorkoutActions extends StatelessWidget {
  const WorkoutPreviewWorkoutActions({super.key});

  @override
  Widget build(BuildContext context) {
    return EditDeleteActions(
      displayAsPopupMenu: context.isMobileSize,
      onEditSelected: () => _editWorkout(context),
      onDeleteSelected: () => _deleteWorkout(context),
    );
  }

  void _editWorkout(BuildContext context) {
    final WorkoutPreviewBloc bloc = context.read<WorkoutPreviewBloc>();
    final DateTime? date = bloc.state.date;
    final String? workoutId = bloc.workoutId;
    if (date != null && workoutId != null) {
      navigateTo(
        WorkoutCreatorRoute(
          date: date.toPathFormat(),
          workoutId: workoutId,
        ),
      );
    }
  }

  Future<void> _deleteWorkout(BuildContext context) async {
    final WorkoutPreviewBloc bloc = context.read<WorkoutPreviewBloc>();
    final str = Str.of(context);
    final bool confirmed = await askForConfirmation(
      title: Text(str.workoutPreviewDeletionConfirmationTitle),
      content: Text(str.workoutPreviewDeletionConfirmationMessage),
      confirmButtonLabel: str.delete,
      confirmButtonColor: Theme.of(context).colorScheme.error,
    );
    if (confirmed == true) {
      bloc.add(const WorkoutPreviewEventDeleteWorkout());
    }
  }
}
