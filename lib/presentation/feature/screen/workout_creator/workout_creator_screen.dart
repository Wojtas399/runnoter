import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/cubit/workout_creator/workout_creator_cubit.dart';
import '../../../component/cubit_with_status_listener_component.dart';
import '../../../component/page_not_found_component.dart';
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
        WorkoutCreatorCubitInfo, dynamic>(
      onInfo: (WorkoutCreatorCubitInfo info) => _manageInfo(context, info),
      child: child,
    );
  }

  void _manageInfo(BuildContext context, WorkoutCreatorCubitInfo info) {
    switch (info) {
      case WorkoutCreatorCubitInfo.workoutAdded:
        _onWorkoutAddedInfo(context);
        break;
      case WorkoutCreatorCubitInfo.workoutUpdated:
        _onWorkoutUpdatedInfo(context);
        break;
    }
  }

  void _onWorkoutAddedInfo(BuildContext context) {
    navigateBack();
    showSnackbarMessage(Str.of(context).workoutCreatorAddedWorkoutMessage);
  }

  void _onWorkoutUpdatedInfo(BuildContext context) {
    navigateBack();
    showSnackbarMessage(Str.of(context).workoutCreatorUpdatedWorkoutMessage);
  }
}
