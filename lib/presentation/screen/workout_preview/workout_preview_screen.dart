import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/workout_preview/workout_preview_bloc.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'workout_preview_content.dart';

@RoutePage()
class WorkoutPreviewScreen extends StatelessWidget {
  final String? workoutId;

  const WorkoutPreviewScreen({
    super.key,
    @PathParam('workoutId') this.workoutId,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      workoutId: workoutId,
      child: const _BlocListener(
        child: WorkoutPreviewContent(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final String? workoutId;
  final Widget child;

  const _BlocProvider({
    required this.workoutId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => WorkoutPreviewBloc(
        workoutId: workoutId,
        workoutRepository: context.read<WorkoutRepository>(),
      )..add(
          const WorkoutPreviewEventInitialize(),
        ),
      child: child,
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
