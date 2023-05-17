import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/model/workout.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/calendar/calendar_component.dart';
import '../../component/calendar/calendar_component_cubit.dart';
import '../../config/navigation/routes.dart';
import '../../formatter/workout_status_formatter.dart';
import '../../service/navigator_service.dart';
import 'calendar_cubit.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _CubitProvider(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: _Calendar(),
      ),
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
      create: (BuildContext context) => CalendarCubit(
        authService: context.read<AuthService>(),
        workoutRepository: context.read<WorkoutRepository>(),
      ),
      child: child,
    );
  }
}

class _Calendar extends StatelessWidget {
  const _Calendar();

  @override
  Widget build(BuildContext context) {
    final List<Workout>? workouts = context.select(
      (CalendarCubit cubit) => cubit.state,
    );

    return Calendar(
      workoutDays: [...?workouts]
          .map(
            (Workout workout) => WorkoutDay(
              date: workout.date,
              workoutStatusIcon: Icon(
                workout.status.toIcon(),
                color: workout.status.toColor(),
              ),
            ),
          )
          .toList(),
      onMonthChanged: (
        DateTime firstDisplayingDate,
        DateTime lastDisplayingDate,
      ) {
        _onMonthChanged(context, firstDisplayingDate, lastDisplayingDate);
      },
      onDayPressed: (DateTime date) {
        _onDayPressed(context, date);
      },
    );
  }

  void _onMonthChanged(
    BuildContext context,
    DateTime firstDisplayingDate,
    DateTime lastDisplayingDate,
  ) {
    context.read<CalendarCubit>().monthChanged(
          firstDisplayingDate: firstDisplayingDate,
          lastDisplayingDate: lastDisplayingDate,
        );
  }

  void _onDayPressed(BuildContext context, DateTime date) {
    navigateTo(
      context: context,
      route: DayPreviewRoute(date: date),
    );
  }
}
