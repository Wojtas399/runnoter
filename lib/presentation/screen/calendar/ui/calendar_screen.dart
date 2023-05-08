import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/model/workout.dart';
import '../../../../domain/repository/workout_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../component/calendar/calendar_component.dart';
import '../../../component/calendar/calendar_component_cubit.dart';
import '../../../formatter/workout_status_formatter.dart';
import '../bloc/calendar_bloc.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: _Calendar(),
        ),
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
      create: (BuildContext context) => CalendarBloc(
        dateService: DateService(),
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
      (CalendarBloc bloc) => bloc.state.workouts,
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
    );
  }

  void _onMonthChanged(
    BuildContext context,
    DateTime firstDisplayingDate,
    DateTime lastDisplayingDate,
  ) {
    context.read<CalendarBloc>().add(
          CalendarEventMonthChanged(
            firstDisplayingDate: firstDisplayingDate,
            lastDisplayingDate: lastDisplayingDate,
          ),
        );
  }
}
