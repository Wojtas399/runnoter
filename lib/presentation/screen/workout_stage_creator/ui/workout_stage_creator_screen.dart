import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/workout_stage_creator_bloc.dart';
import 'workout_stage_creator_content.dart';

class WorkoutStageCreatorScreen extends StatelessWidget {
  const WorkoutStageCreatorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: WorkoutStageCreatorContent(),
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
