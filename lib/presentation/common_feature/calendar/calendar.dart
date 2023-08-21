import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/calendar_date_range_data.dart';
import '../../../domain/cubit/calendar_date_range_data_cubit.dart';
import '../../component/calendar/bloc/calendar_component_bloc.dart';
import '../../component/calendar/calendar_component.dart';
import '../../config/navigation/router.dart';
import '../../dialog/day_preview/day_preview_dialog.dart';
import '../../dialog/day_preview/day_preview_dialog_actions.dart';
import '../../formatter/date_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';

class Calendar extends StatelessWidget {
  final String userId;

  const Calendar({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarDateRangeDataCubit(userId: userId),
      child: BlocBuilder<CalendarDateRangeDataCubit, CalendarDateRangeData>(
        builder: (context, dateRangeData) {
          return CalendarComponent(
            dateRangeType: DateRangeType.month,
            dateRangeData: dateRangeData,
            onDateRangeChanged: (DateTime startDate, DateTime endDate) =>
                _onDateRangeChanged(context, startDate, endDate),
            onMonthDayPressed: (DateTime date) =>
                _onMonthDayPressed(context, date),
            onWorkoutPressed: _navigateToWorkoutPreview,
            onRacePressed: _navigateToRacePreview,
            onAddWorkout: _navigateToWorkoutCreator,
            onAddRace: _navigateToRaceCreator,
          );
        },
      ),
    );
  }

  void _onDateRangeChanged(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
  ) {
    context.read<CalendarDateRangeDataCubit>().dateRangeChanged(
          startDate: startDate,
          endDate: endDate,
        );
  }

  Future<void> _onMonthDayPressed(BuildContext context, DateTime date) async {
    final DayPreviewDialogAction? action =
        await showDialogDependingOnScreenSize(
      DayPreviewDialog(userId: userId, date: date),
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
        _navigateToWorkoutPreview(action.workoutId);
        break;
      case DayPreviewDialogActionShowRace():
        _navigateToRacePreview(action.raceId);
        break;
    }
  }

  void _navigateToWorkoutPreview(String workoutId) {
    navigateTo(WorkoutPreviewRoute(
      userId: userId,
      workoutId: workoutId,
    ));
  }

  void _navigateToRacePreview(String raceId) {
    navigateTo(RacePreviewRoute(
      userId: userId,
      raceId: raceId,
    ));
  }

  void _navigateToWorkoutCreator(DateTime date) {
    navigateTo(WorkoutCreatorRoute(
      userId: userId,
      dateStr: date.toPathFormat(),
    ));
  }

  void _navigateToRaceCreator(DateTime date) {
    navigateTo(RaceCreatorRoute(
      userId: userId,
      dateStr: date.toPathFormat(),
    ));
  }
}
