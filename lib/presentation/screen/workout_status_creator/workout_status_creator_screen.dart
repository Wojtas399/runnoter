import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/workout_status_creator/workout_status_creator_bloc.dart';
import '../../../domain/entity/workout_status.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/scrollable_content_component.dart';
import '../../component/text_field_component.dart';
import '../../formatter/decimal_text_input_formatter.dart';
import '../../formatter/minutes_or_seconds_input_formatter.dart';
import '../../formatter/mood_rate_formatter.dart';
import '../../formatter/workout_status_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';

part 'workout_status_creator_average_pace.dart';
part 'workout_status_creator_content.dart';
part 'workout_status_creator_finished_workout_form.dart';
part 'workout_status_creator_status_type.dart';

enum WorkoutStatusCreatorType {
  updateStatus,
  finishWorkout,
}

class WorkoutStatusCreatorArguments {
  final String workoutId;
  final WorkoutStatusCreatorType creatorType;

  const WorkoutStatusCreatorArguments({
    required this.workoutId,
    required this.creatorType,
  });
}

class WorkoutStatusCreatorScreen extends StatelessWidget {
  final WorkoutStatusCreatorArguments arguments;

  const WorkoutStatusCreatorScreen({
    super.key,
    required this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      arguments: arguments,
      child: const _BlocListener(
        child: _Content(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final WorkoutStatusCreatorArguments arguments;
  final Widget child;

  const _BlocProvider({
    required this.arguments,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    WorkoutStatusType? workoutStatusType;
    if (arguments.creatorType == WorkoutStatusCreatorType.finishWorkout) {
      workoutStatusType = WorkoutStatusType.done;
    }

    return BlocProvider(
      create: (BuildContext context) => WorkoutStatusCreatorBloc(
        authService: context.read<AuthService>(),
        workoutRepository: context.read<WorkoutRepository>(),
      )..add(
          WorkoutStatusCreatorEventInitialize(
            workoutId: arguments.workoutId,
            workoutStatusType: workoutStatusType,
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
    return BlocWithStatusListener<WorkoutStatusCreatorBloc,
        WorkoutStatusCreatorState, WorkoutStatusCreatorBlocInfo, dynamic>(
      onInfo: (WorkoutStatusCreatorBlocInfo info) {
        _manageInfo(context, info);
      },
      child: child,
    );
  }

  void _manageInfo(BuildContext context, WorkoutStatusCreatorBlocInfo info) {
    switch (info) {
      case WorkoutStatusCreatorBlocInfo.workoutStatusSaved:
        navigateBack(context: context);
        showSnackbarMessage(
          context: context,
          message: Str.of(context).workoutStatusCreatorSavedStatusMessage,
        );
        break;
      case WorkoutStatusCreatorBlocInfo.workoutStatusInitialized:
        break;
    }
  }
}
