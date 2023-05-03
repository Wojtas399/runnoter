import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/workout_status.dart';
import '../../../../domain/repository/workout_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../component/big_button_component.dart';
import '../../../component/bloc_with_status_listener_component.dart';
import '../../../component/scrollable_content_component.dart';
import '../../../component/text_field_component.dart';
import '../../../formatter/decimal_text_input_formatter.dart';
import '../../../formatter/minutes_or_seconds_input_formatter.dart';
import '../../../formatter/mood_rate_formatter.dart';
import '../../../formatter/workout_status_formatter.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';
import '../../../service/utils.dart';
import '../bloc/workout_status_creator_bloc.dart';

part 'workout_status_creator_average_pace.dart';
part 'workout_status_creator_content.dart';
part 'workout_status_creator_status_type.dart';

abstract class WorkoutStatusCreatorArguments {
  final String workoutId;

  const WorkoutStatusCreatorArguments({
    required this.workoutId,
  });
}

class WorkoutStatusCreatorUpdateStatusArguments
    extends WorkoutStatusCreatorArguments {
  const WorkoutStatusCreatorUpdateStatusArguments({
    required super.workoutId,
  });
}

class WorkoutStatusCreatorFinishWorkoutArguments
    extends WorkoutStatusCreatorArguments {
  WorkoutStatusCreatorFinishWorkoutArguments({
    required super.workoutId,
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
    if (arguments is WorkoutStatusCreatorFinishWorkoutArguments) {
      workoutStatusType = WorkoutStatusType.completed;
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
        WorkoutStatusCreatorState, WorkoutStatusCreatorInfo, dynamic>(
      onInfo: (WorkoutStatusCreatorInfo info) {
        _manageInfo(context, info);
      },
      child: child,
    );
  }

  void _manageInfo(BuildContext context, WorkoutStatusCreatorInfo info) {
    switch (info) {
      case WorkoutStatusCreatorInfo.workoutStatusSaved:
        navigateBack(context: context);
        showSnackbarMessage(
          context: context,
          message: AppLocalizations.of(context)!
              .workout_status_creator_saved_status_info,
        );
        break;
      case WorkoutStatusCreatorInfo.workoutStatusInitialized:
        break;
    }
  }
}
