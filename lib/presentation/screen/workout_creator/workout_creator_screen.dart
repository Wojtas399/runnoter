import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/workout_creator/workout_creator_bloc.dart';
import '../../../domain/entity/workout.dart';
import '../../../domain/entity/workout_stage.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/scrollable_content_component.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/label_text_components.dart';
import '../../component/text_field_component.dart';
import '../../formatter/workout_stage_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';
import '../workout_stage_creator/workout_stage_creator_screen.dart';

part 'workout_creator_content.dart';
part 'workout_creator_submit_button.dart';
part 'workout_creator_workout_stage_item.dart';
part 'workout_creator_workout_stages_list.dart';
part 'workout_creator_workout_stages_section.dart';

abstract class WorkoutCreatorArguments {
  final DateTime date;

  const WorkoutCreatorArguments({
    required this.date,
  });
}

class WorkoutCreatorAddModeArguments extends WorkoutCreatorArguments {
  const WorkoutCreatorAddModeArguments({
    required super.date,
  });
}

class WorkoutCreatorEditModeArguments extends WorkoutCreatorArguments {
  final String workoutId;

  const WorkoutCreatorEditModeArguments({
    required super.date,
    required this.workoutId,
  });
}

class WorkoutCreatorScreen extends StatelessWidget {
  final WorkoutCreatorArguments arguments;

  const WorkoutCreatorScreen({
    super.key,
    required this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    final WorkoutCreatorArguments arguments = this.arguments;
    String? workoutId;
    if (arguments is WorkoutCreatorEditModeArguments) {
      workoutId = arguments.workoutId;
    }
    return _BlocProvider(
      date: arguments.date,
      workoutId: workoutId,
      child: const _BlocListener(
        child: _Content(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final DateTime date;
  final String? workoutId;
  final Widget child;

  const _BlocProvider({
    required this.date,
    required this.workoutId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => WorkoutCreatorBloc(
        authService: context.read<AuthService>(),
        workoutRepository: context.read<WorkoutRepository>(),
      )..add(
          WorkoutCreatorEventInitialize(
            date: date,
            workoutId: workoutId,
          ),
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
    navigateBack(context: context);
    showSnackbarMessage(
      context: context,
      message: Str.of(context).workoutCreatorAddedWorkoutMessage,
    );
  }

  void _onWorkoutUpdatedInfo(BuildContext context) {
    navigateBack(context: context);
    showSnackbarMessage(
      context: context,
      message: Str.of(context).workoutCreatorUpdatedWorkoutMessage,
    );
  }
}
