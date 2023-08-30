import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/workout_stage.dart';
import '../../../domain/bloc/workout_stage_creator/workout_stage_creator_bloc.dart';
import '../../service/navigator_service.dart';
import 'workout_stage_creator_content.dart';

class WorkoutStageCreatorDialog extends StatelessWidget {
  final WorkoutStage? stage;

  const WorkoutStageCreatorDialog({super.key, this.stage});

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      stage: stage,
      child: const _BlocListener(
        child: WorkoutStageCreatorContent(),
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
          popRoute(result: state.stageToSubmit);
        }
      },
      child: child,
    );
  }
}
