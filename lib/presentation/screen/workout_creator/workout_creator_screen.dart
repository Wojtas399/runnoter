import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/workout_creator/workout_creator_bloc.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../extension/string_extensions.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'workout_creator_content.dart';

@RoutePage()
class WorkoutCreatorScreen extends StatelessWidget {
  final String? userId;
  final String? date;
  final String? workoutId;

  const WorkoutCreatorScreen({
    super.key,
    @PathParam('userId') this.userId,
    @PathParam('date') this.date,
    @PathParam('workoutId') this.workoutId,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime? date = this.date?.toDateTime();
    return _BlocProvider(
      userId: userId,
      date: date,
      workoutId: workoutId,
      child: const _BlocListener(
        child: WorkoutCreatorContent(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final String? userId;
  final DateTime? date;
  final String? workoutId;
  final Widget child;

  const _BlocProvider({
    required this.userId,
    required this.date,
    required this.workoutId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return userId != null
        ? BlocProvider(
            create: (BuildContext context) => WorkoutCreatorBloc(
              userId: userId!,
              date: date,
              workoutId: workoutId,
            )..add(const WorkoutCreatorEventInitialize()),
            child: child,
          )
        : const Text('User not found');
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
