import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/additional_model/workout_stage.dart';
import '../../../cubit/workout_stage_creator/workout_stage_creator_cubit.dart';
import '../../../service/navigator_service.dart';
import 'workout_stage_creator_content.dart';

class WorkoutStageCreatorDialog extends StatelessWidget {
  final WorkoutStage? stage;

  const WorkoutStageCreatorDialog({super.key, this.stage});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutStageCreatorCubit(
        originalStage: stage,
      )..initialize(),
      child: const _CubitListener(
        child: WorkoutStageCreatorContent(),
      ),
    );
  }
}

class _CubitListener extends StatelessWidget {
  final Widget child;

  const _CubitListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkoutStageCreatorCubit, WorkoutStageCreatorState>(
      listenWhen: (_, currentState) => currentState.stageToAdd != null,
      listener: (_, WorkoutStageCreatorState state) {
        popRoute(result: state.stageToAdd);
      },
      child: child,
    );
  }
}
