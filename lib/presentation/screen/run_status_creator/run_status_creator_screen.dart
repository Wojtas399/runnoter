import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/run_status_creator/run_status_creator_bloc.dart';
import '../../../domain/entity/run_status.dart';
import '../../../domain/entity/settings.dart';
import '../../../domain/repository/race_repository.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/duration_input_component.dart';
import '../../component/scrollable_content_component.dart';
import '../../component/text/label_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../component/text_field_component.dart';
import '../../config/ui_sizes.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/decimal_text_input_formatter.dart';
import '../../formatter/distance_unit_formatter.dart';
import '../../formatter/minutes_or_seconds_input_formatter.dart';
import '../../formatter/mood_rate_formatter.dart';
import '../../formatter/pace_unit_formatter.dart';
import '../../formatter/run_status_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/pace_unit_service.dart';
import '../../service/utils.dart';

part 'run_status_creator_avg_heart_rate.dart';
part 'run_status_creator_avg_pace.dart';
part 'run_status_creator_comment.dart';
part 'run_status_creator_content.dart';
part 'run_status_creator_covered_distance.dart';
part 'run_status_creator_params_form.dart';
part 'run_status_creator_status_type.dart';

sealed class RunStatusCreatorArguments {
  final String entityId;

  const RunStatusCreatorArguments({
    required this.entityId,
  });
}

class WorkoutRunStatusCreatorArguments extends RunStatusCreatorArguments {
  const WorkoutRunStatusCreatorArguments({
    required super.entityId,
  });
}

class RaceRunStatusCreatorArguments extends RunStatusCreatorArguments {
  const RaceRunStatusCreatorArguments({
    required super.entityId,
  });
}

@RoutePage()
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
    return BlocProvider(
      create: (BuildContext context) => RunStatusCreatorBloc(
        entityType: switch (arguments) {
          WorkoutRunStatusCreatorArguments() => EntityType.workout,
          RaceRunStatusCreatorArguments() => EntityType.race,
        },
        entityId: arguments.entityId,
        authService: context.read<AuthService>(),
        workoutRepository: context.read<WorkoutRepository>(),
        raceRepository: context.read<RaceRepository>(),
      )..add(
          const RunStatusCreatorEventInitialize(),
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
        navigateBack();
        showSnackbarMessage(Str.of(context).runStatusCreatorSavedStatusMessage);
        break;
    }
  }
}
