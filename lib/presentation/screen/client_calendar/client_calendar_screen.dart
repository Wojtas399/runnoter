import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/client/client_bloc.dart';
import '../../../domain/cubit/client_calendar_cubit.dart';
import '../../component/calendar/calendar_component.dart';
import '../../config/navigation/router.dart';
import '../../dialog/day_preview/day_preview_dialog.dart';
import '../../dialog/day_preview/day_preview_dialog_actions.dart';
import '../../formatter/date_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';

@RoutePage()
class ClientCalendarScreen extends StatelessWidget {
  const ClientCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClientCalendarCubit(
        clientId: context.read<ClientBloc>().clientId,
      ),
      child: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: _Calendar(),
        ),
      ),
    );
  }
}

class _Calendar extends StatefulWidget {
  const _Calendar();

  @override
  State<StatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends State<_Calendar> {
  @override
  Widget build(BuildContext context) {
    final ClientCalendarState activities = context.select(
      (ClientCalendarCubit cubit) => cubit.state,
    );

    return Calendar(
      workouts: [...?activities.workouts],
      races: [...?activities.races],
      onDateRangeChanged: _dateRangeChanged,
      onWorkoutPressed: _navigateToWorkout,
      onRacePressed: _navigateToRace,
      onAddWorkout: _navigateToWorkoutCreator,
      onAddRace: _navigateToRaceCreator,
      onDayPressed: (DateTime date) => _onDayPressed(context, date),
    );
  }

  void _dateRangeChanged(DateTime startDate, DateTime endDate) {
    context.read<ClientCalendarCubit>().dateRangeChanged(
          startDate: startDate,
          endDate: endDate,
        );
  }

  void _navigateToWorkout(String workoutId) {
    navigateTo(WorkoutPreviewRoute(
      userId: context.read<ClientBloc>().clientId,
      workoutId: workoutId,
    ));
  }

  void _navigateToRace(String raceId) {
    navigateTo(RacePreviewRoute(raceId: raceId));
  }

  void _navigateToWorkoutCreator(DateTime date) {
    navigateTo(
      WorkoutCreatorRoute(
        userId: context.read<ClientBloc>().clientId,
        date: date.toPathFormat(),
      ),
    );
  }

  void _navigateToRaceCreator(DateTime date) {
    navigateTo(RaceCreatorRoute(dateStr: date.toPathFormat()));
  }

  Future<void> _onDayPressed(BuildContext context, DateTime date) async {
    final DayPreviewDialogAction? action =
        await showDialogDependingOnScreenSize(DayPreviewDialog(date: date));
    if (action == null) return;
    switch (action) {
      case DayPreviewDialogActionAddWorkout():
        _navigateToWorkoutCreator(action.date);
        break;
      case DayPreviewDialogActionAddRace():
        _navigateToRaceCreator(action.date);
        break;
      case DayPreviewDialogActionShowWorkout():
        _navigateToWorkout(action.workoutId);
        break;
      case DayPreviewDialogActionShowRace():
        _navigateToRace(action.raceId);
        break;
    }
  }
}
