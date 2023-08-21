import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/activities.dart';
import '../../../domain/additional_model/calendar_date_range_data.dart';
import '../../../domain/bloc/client/client_bloc.dart';
import '../../../domain/cubit/client_calendar_cubit.dart';
import '../../component/body/big_body_component.dart';
import '../../component/calendar/calendar_component.dart';
import '../../component/card_body_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
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
        child: BigBody(
          child: Paddings24(
            child: ResponsiveLayout(
              mobileBody: _Calendar(),
              desktopBody: CardBody(child: _Calendar()),
            ),
          ),
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
    final Activities activities = context.select(
      (ClientCalendarCubit cubit) => cubit.state,
    );

    return Calendar(
      dateRangeData: CalendarDateRangeData(
        healthMeasurements: const [],
        workouts: [...?activities.workouts],
        races: [...?activities.races],
      ),
      onDateRangeChanged: _dateRangeChanged,
      onWorkoutPressed: _navigateToWorkout,
      onRacePressed: _navigateToRace,
      onAddWorkout: _navigateToWorkoutCreator,
      onAddRace: _navigateToRaceCreator,
      onMonthDayPressed: (DateTime date) => _onDayMonthPressed(context, date),
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
    navigateTo(RacePreviewRoute(
      userId: context.read<ClientBloc>().clientId,
      raceId: raceId,
    ));
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
    navigateTo(RaceCreatorRoute(
      userId: context.read<ClientBloc>().clientId,
      dateStr: date.toPathFormat(),
    ));
  }

  Future<void> _onDayMonthPressed(BuildContext context, DateTime date) async {
    final DayPreviewDialogAction? action =
        await showDialogDependingOnScreenSize(
      DayPreviewDialog(userId: context.read<ClientBloc>().clientId, date: date),
    );
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
