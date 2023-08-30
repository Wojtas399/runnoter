import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/workout_creator/workout_creator_bloc.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/page_not_found_component.dart';
import '../../extension/string_extensions.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
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
            create: (_) => WorkoutCreatorBloc(
              userId: userId!,
              date: date,
              workoutId: workoutId,
            )..add(const WorkoutCreatorEventInitialize()),
            child: const _BlocListener(
              child: WorkoutCreatorContent(),
            ),
          );
  }
}

class _BlocListener extends StatelessWidget {
  final Widget child;

  const _BlocListener({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<WorkoutCreatorBloc, WorkoutCreatorState,
        WorkoutCreatorBlocInfo, dynamic>(
      onInfo: (WorkoutCreatorBlocInfo info) {
        _manageInfo(context, info);
      },
      child: child,
    );
  }

  void _manageInfo(BuildContext context, WorkoutCreatorBlocInfo info) {
    switch (info) {
      case WorkoutCreatorBlocInfo.editModeInitialized:
        break;
      case WorkoutCreatorBlocInfo.workoutAdded:
        _onWorkoutAddedInfo(context);
        break;
      case WorkoutCreatorBlocInfo.workoutUpdated:
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
