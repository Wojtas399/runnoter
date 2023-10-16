import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/cubit_with_status_listener_component.dart';
import '../../../component/page_not_found_component.dart';
import '../../../cubit/workout_creator/workout_creator_cubit.dart';
import '../../../formatter/string_formatter.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';
import 'workout_creator_content.dart';

@RoutePage()
class WorkoutCreatorScreen extends StatelessWidget {
  final String? userId;
  final String? dateStr;
  final String? workoutId;

  const WorkoutCreatorScreen({
    super.key,
    @PathParam('userId') this.userId,
    @PathParam('dateStr') this.dateStr,
    @PathParam('workoutId') this.workoutId,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime? date = dateStr?.toDateTime();
    return userId == null
        ? const PageNotFound()
        : BlocProvider(
            create: (_) => WorkoutCreatorCubit(
              userId: userId!,
              date: date,
              workoutId: workoutId,
            )..initialize(),
            child: const _CubitListener(
              child: WorkoutCreatorContent(),
            ),
          );
  }
}

class _CubitListener extends StatelessWidget {
  final Widget child;

  const _CubitListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return CubitWithStatusListener<WorkoutCreatorCubit, WorkoutCreatorState,
        WorkoutCreatorCubitInfo, WorkoutCreatorCubitError>(
      onInfo: (WorkoutCreatorCubitInfo info) => _manageInfo(context, info),
      onError: (WorkoutCreatorCubitError error) => _manageError(context, error),
      child: child,
    );
  }

  void _manageInfo(BuildContext context, WorkoutCreatorCubitInfo info) {
    final str = Str.of(context);
    switch (info) {
      case WorkoutCreatorCubitInfo.workoutAdded:
        navigateBack();
        showSnackbarMessage(str.workoutCreatorAddedWorkoutMessage);
      case WorkoutCreatorCubitInfo.workoutUpdated:
        navigateBack();
        showSnackbarMessage(str.workoutCreatorUpdatedWorkoutMessage);
    }
  }

  Future<void> _manageError(
    BuildContext context,
    WorkoutCreatorCubitError error,
  ) async {
    final str = Str.of(context);
    switch (error) {
      case WorkoutCreatorCubitError.workoutNoLongerExists:
        await showMessageDialog(
          title: str.workoutCreatorWorkoutNoLongerExistsDialogTitle,
          message: str.workoutCreatorWorkoutNoLongerExistsDialogMessage,
        );
        if (context.mounted) {
          context.router.removeLast();
          context.router.removeLast();
        }
    }
  }
}
