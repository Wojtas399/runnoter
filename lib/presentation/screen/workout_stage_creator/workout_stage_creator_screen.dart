import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/workout_stage_creator/workout_stage_creator_bloc.dart';
import '../../component/text_field_component.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/decimal_text_input_formatter.dart';
import '../../formatter/distance_unit_formatter.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';

part 'workout_stage_creator_app_bar.dart';
part 'workout_stage_creator_content.dart';
part 'workout_stage_creator_distance_form.dart';
part 'workout_stage_creator_series_form.dart';

class WorkoutStageCreatorScreen extends StatelessWidget {
  const WorkoutStageCreatorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _BlocListener(
        child: WorkoutStageCreatorContent(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final Widget child;

  const _BlocProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutStageCreatorBloc(),
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
        if (state is WorkoutStageCreatorStateSubmitted) {
          navigateBack(context: context, result: state.workoutStage);
        }
      },
      child: child,
    );
  }
}
