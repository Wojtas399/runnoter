import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/workout_stage_creator/workout_stage_creator_bloc.dart';
import '../../../domain/entity/workout_stage.dart';
import '../../component/text_field_component.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/decimal_text_input_formatter.dart';
import '../../formatter/distance_unit_formatter.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';

part 'workout_stage_creator_content.dart';
part 'workout_stage_creator_distance_form.dart';
part 'workout_stage_creator_form.dart';
part 'workout_stage_creator_series_form.dart';

class WorkoutStageCreatorScreen extends StatelessWidget {
  final WorkoutStage? stage;

  const WorkoutStageCreatorScreen({
    super.key,
    this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      stage: stage,
      child: _BlocListener(
        child: context.isMobileSize
            ? const _FullScreenDialogContent()
            : const _NormalDialogContent(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final WorkoutStage? stage;
  final Widget child;

  const _BlocProvider({
    required this.stage,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutStageCreatorBloc(
        originalStage: stage,
      )..add(
          const WorkoutStageCreatorEventInitialize(),
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
    return BlocListener<WorkoutStageCreatorBloc, WorkoutStageCreatorState>(
      listener: (BuildContext context, WorkoutStageCreatorState state) {
        if (state.stageToSubmit != null) {
          navigateBack(context: context, result: state.stageToSubmit);
        }
      },
      child: child,
    );
  }
}
