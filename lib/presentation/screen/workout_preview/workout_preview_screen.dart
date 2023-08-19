import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/workout_preview/workout_preview_bloc.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/page_not_found_component.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'workout_preview_content.dart';

@RoutePage()
class WorkoutPreviewScreen extends StatelessWidget {
  final String? userId;
  final String? workoutId;

  const WorkoutPreviewScreen({
    super.key,
    @PathParam('userId') this.userId,
    @PathParam('workoutId') this.workoutId,
  });

  @override
  Widget build(BuildContext context) {
    return userId == null
        ? const PageNotFound()
        : BlocProvider(
            create: (_) => WorkoutPreviewBloc(
              userId: userId!,
              workoutId: workoutId,
            )..add(const WorkoutPreviewEventInitialize()),
            child: const _BlocListener(
              child: WorkoutPreviewContent(),
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
    return BlocWithStatusListener<WorkoutPreviewBloc, WorkoutPreviewState,
        WorkoutPreviewBlocInfo, dynamic>(
      onInfo: (WorkoutPreviewBlocInfo info) {
        _manageInfo(context, info);
      },
      child: child,
    );
  }

  void _manageInfo(BuildContext context, WorkoutPreviewBlocInfo info) {
    switch (info) {
      case WorkoutPreviewBlocInfo.workoutDeleted:
        navigateBack();
        _showInfoAboutDeletedWorkout(context);
        break;
    }
  }

  void _showInfoAboutDeletedWorkout(BuildContext context) {
    showSnackbarMessage(Str.of(context).workoutPreviewDeletedWorkoutMessage);
  }
}
