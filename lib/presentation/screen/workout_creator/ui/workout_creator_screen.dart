import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/workout_creator_bloc.dart';
import '../bloc/workout_creator_event.dart';
import 'workout_creator_content.dart';

class WorkoutCreatorScreen extends StatelessWidget {
  final DateTime date;

  const WorkoutCreatorScreen({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      date: date,
      child: const WorkoutCreatorContent(),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final DateTime date;
  final Widget child;

  const _BlocProvider({
    required this.date,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutCreatorBloc()
        ..add(
          WorkoutCreatorEventInitialize(date: date),
        ),
      child: child,
    );
  }
}
