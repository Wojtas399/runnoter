import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../../domain/additional_model/calendar_date_range_data.dart';
import '../../../domain/cubit/calendar_cubit.dart';
import '../../../domain/service/auth_service.dart';
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
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarCubit(),
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
    final CalendarDateRangeData dateRangeData = context.select(
      (CalendarCubit cubit) => cubit.state,
    );

    return Calendar(
      dateRangeData: dateRangeData,
      onWorkoutPressed: _navigateToWorkout,
      onRacePressed: _navigateToRace,
      onAddWorkout: _navigateToWorkoutCreator,
      onAddRace: _navigateToRaceCreator,
      onDateRangeChanged: (DateTime firstDay, DateTime lastDay) =>
          _onDateRangeChanged(context, firstDay, lastDay),
      onMonthDayPressed: (DateTime date) => _onMonthDayPressed(context, date),
    );
  }

  void _onDateRangeChanged(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
  ) {
    context.read<CalendarCubit>().dateRangeChanged(
          startDate: startDate,
          endDate: endDate,
        );
  }

  Future<void> _onMonthDayPressed(BuildContext context, DateTime date) async {
    final DayPreviewDialogAction? action = await _askForDayAction(date);
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

  Future<void> _navigateToWorkout(String workoutId) async {
    final String? loggedUserId = await getIt<AuthService>().loggedUserId$.first;
    navigateTo(WorkoutPreviewRoute(
      userId: loggedUserId,
      workoutId: workoutId,
    ));
  }

  Future<void> _navigateToRace(String raceId) async {
    final String? loggedUserId = await getIt<AuthService>().loggedUserId$.first;
    navigateTo(RacePreviewRoute(
      userId: loggedUserId,
      raceId: raceId,
    ));
  }

  Future<void> _navigateToWorkoutCreator(DateTime date) async {
    final String? loggedUserId = await getIt<AuthService>().loggedUserId$.first;
    navigateTo(WorkoutCreatorRoute(
      userId: loggedUserId,
      date: date.toPathFormat(),
    ));
  }

  Future<void> _navigateToRaceCreator(DateTime date) async {
    final String? loggedUserId = await getIt<AuthService>().loggedUserId$.first;
    navigateTo(RaceCreatorRoute(
      userId: loggedUserId,
      dateStr: date.toPathFormat(),
    ));
  }

  Future<DayPreviewDialogAction?> _askForDayAction(DateTime date) async {
    final String? loggedUserId = await getIt<AuthService>().loggedUserId$.first;
    if (loggedUserId == null) return null;
    return await showDialogDependingOnScreenSize(
      DayPreviewDialog(userId: loggedUserId, date: date),
    );
  }
}
