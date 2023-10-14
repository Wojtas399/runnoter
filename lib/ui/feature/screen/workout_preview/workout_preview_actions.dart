import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/cubit/workout_preview/workout_preview_cubit.dart';
import '../../../component/edit_delete_popup_menu_component.dart';
import '../../../config/navigation/router.dart';
import '../../../extension/context_extensions.dart';
import '../../../formatter/date_formatter.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';

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
    final WorkoutPreviewCubit cubit = context.read<WorkoutPreviewCubit>();
    final DateTime? date = cubit.state.date;
    final String workoutId = cubit.workoutId;
    if (date != null) {
      navigateTo(
        WorkoutCreatorRoute(
          userId: cubit.userId,
          dateStr: date.toPathFormat(),
          workoutId: workoutId,
        ),
      );
    }
  }

  Future<void> _deleteWorkout(BuildContext context) async {
    final WorkoutPreviewCubit cubit = context.read<WorkoutPreviewCubit>();
    final str = Str.of(context);
    final bool confirmed = await _askForWorkoutDeletionConfirmation(context);
    if (confirmed == true) {
      showLoadingDialog();
      await cubit.deleteWorkout();
      closeLoadingDialog();
      navigateBack();
      showSnackbarMessage(str.workoutPreviewDeletedWorkoutMessage);
    }
  }

  Future<bool> _askForWorkoutDeletionConfirmation(BuildContext context) async {
    final str = Str.of(context);
    return await askForConfirmation(
      title: Text(str.workoutPreviewDeletionConfirmationTitle),
      content: Text(str.workoutPreviewDeletionConfirmationMessage),
      confirmButtonLabel: str.delete,
      confirmButtonColor: Theme.of(context).colorScheme.error,
    );
  }
}
