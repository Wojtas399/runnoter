import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/repository/workout_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../current_week_cubit.dart';
import 'current_week_content.dart';

class CurrentWeekScreen extends StatelessWidget {
  const CurrentWeekScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _CubitProvider(
      child: CurrentWeekContent(),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final Widget child;

  const _CubitProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CurrentWeekCubit(
        dateService: DateService(),
        authService: context.read<AuthService>(),
        workoutRepository: context.read<WorkoutRepository>(),
      )..initialize(),
      child: child,
    );
  }
}
