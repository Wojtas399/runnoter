import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/run_status_creator/run_status_creator_bloc.dart';
import '../../../domain/entity/run_status.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/scrollable_content_component.dart';
import '../../component/text_field_component.dart';
import '../../formatter/decimal_text_input_formatter.dart';
import '../../formatter/minutes_or_seconds_input_formatter.dart';
import '../../formatter/mood_rate_formatter.dart';
import '../../formatter/run_status_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';

part 'run_status_creator_average_pace.dart';
part 'run_status_creator_content.dart';
part 'run_status_creator_finished_workout_form.dart';
part 'run_status_creator_status_type.dart';

enum RunStatusCreatorType {
  updateStatus,
  finishWorkout,
}

class RunStatusCreatorArguments {
  final String workoutId;
  final RunStatusCreatorType creatorType;

  const RunStatusCreatorArguments({
    required this.workoutId,
    required this.creatorType,
  });
}

class RunStatusCreatorScreen extends StatelessWidget {
  final RunStatusCreatorArguments arguments;

  const RunStatusCreatorScreen({
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
  final RunStatusCreatorArguments arguments;
  final Widget child;

  const _BlocProvider({
    required this.arguments,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    RunStatusType? runStatusType;
    if (arguments.creatorType == RunStatusCreatorType.finishWorkout) {
      runStatusType = RunStatusType.done;
    }

    return BlocProvider(
      create: (BuildContext context) => RunStatusCreatorBloc(
        authService: context.read<AuthService>(),
        workoutRepository: context.read<WorkoutRepository>(),
      )..add(
          RunStatusCreatorEventInitialize(
            workoutId: arguments.workoutId,
            runStatusType: runStatusType,
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
    return BlocWithStatusListener<RunStatusCreatorBloc, RunStatusCreatorState,
        RunStatusCreatorBlocInfo, dynamic>(
      onInfo: (RunStatusCreatorBlocInfo info) {
        _manageInfo(context, info);
      },
      child: child,
    );
  }

  void _manageInfo(BuildContext context, RunStatusCreatorBlocInfo info) {
    switch (info) {
      case RunStatusCreatorBlocInfo.runStatusSaved:
        navigateBack(context: context);
        showSnackbarMessage(
          context: context,
          message: Str.of(context).runStatusCreatorSavedStatusMessage,
        );
        break;
      case RunStatusCreatorBlocInfo.runStatusInitialized:
        break;
    }
  }
}
