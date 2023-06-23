import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../domain/bloc/calendar/calendar_cubit.dart';
import '../../../domain/entity/competition.dart';
import '../../../domain/entity/workout.dart';
import '../../../domain/repository/competition_repository.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/calendar/calendar_component.dart';
import '../../component/calendar/calendar_component_cubit.dart';
import '../../component/padding/paddings_24.dart';
import '../../formatter/run_status_formatter.dart';
import '../../service/dialog_service.dart';
import '../day_preview/day_preview_screen.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _CubitProvider(
      child: Paddings24(
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
        competitionRepository: context.read<CompetitionRepository>(),
      ),
      child: child,
    );
  }
}

class _Calendar extends StatelessWidget {
  const _Calendar();

  @override
  Widget build(BuildContext context) {
    final CalendarState state = context.select(
      (CalendarCubit cubit) => cubit.state,
    );

    return Calendar(
      activities: [
        ...?state.workouts?.map(
          (Workout workout) => CalendarDayActivity(
            date: workout.date,
            color: workout.status.toColor(context),
          ),
        ),
        ...?state.competitions?.map(
          (Competition competition) => CalendarDayActivity(
            date: competition.date,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
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

  Future<void> _onDayPressed(
    BuildContext context,
    DateTime date,
  ) async {
    await showFullScreenDialog(
      context: context,
      dialog: Provider<WorkoutRepository>.value(
        value: context.read<WorkoutRepository>(),
        child: Provider<CompetitionRepository>.value(
          value: context.read<CompetitionRepository>(),
          child: DayPreviewScreen(date: date),
        ),
      ),
    );
  }
}
