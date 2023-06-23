import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/day_preview/day_preview_cubit.dart';
import '../../../domain/repository/competition_repository.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../service/navigator_service.dart';

class DayPreviewScreen extends StatelessWidget {
  final DateTime date;

  const DayPreviewScreen({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return _CubitProvider(
      date: date,
      child: const _Content(),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final DateTime date;
  final Widget child;

  const _CubitProvider({
    required this.date,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => DayPreviewCubit(
        date: date,
        authService: context.read<AuthService>(),
        workoutRepository: context.read<WorkoutRepository>(),
        competitionRepository: context.read<CompetitionRepository>(),
      )..initialize(),
      child: child,
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Podgląd dnia',
        ),
        leading: IconButton(
          onPressed: () {
            navigateBack(context: context);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: Center(
        child: Text('Day preview'),
      ),
    );
  }
}
