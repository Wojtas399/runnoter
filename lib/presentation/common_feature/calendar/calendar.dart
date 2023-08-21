import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/calendar_date_range_data.dart';
import '../../../domain/cubit/calendar_date_range_data_cubit.dart';
import '../../component/body/big_body_component.dart';
import '../../component/calendar/bloc/calendar_component_bloc.dart';
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

class Calendar extends StatelessWidget {
  final String userId;

  const Calendar({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CalendarDateRangeDataCubit(userId: userId)),
        BlocProvider(
          create: (_) => CalendarComponentBloc()
            ..add(
              const CalendarComponentEventInitialize(
                dateRangeType: DateRangeType.month,
              ),
            ),
        ),
      ],
      child: const SingleChildScrollView(
        child: BigBody(
          child: Paddings24(
            child: ResponsiveLayout(
              mobileBody: _Calendar(),
              desktopBody: CardBody(
                child: _Calendar(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Calendar extends StatelessWidget {
  const _Calendar();

  @override
  Widget build(BuildContext context) {
    final CalendarDateRangeData dateRangeData = context.select(
      (CalendarDateRangeDataCubit cubit) => cubit.state,
    );

    return CalendarComponent(
      dateRangeType: DateRangeType.month,
      dateRangeData: dateRangeData,
      onDateRangeChanged: (DateTime startDate, DateTime endDate) =>
          _onDateRangeChanged(context, startDate, endDate),
      onMonthDayPressed: (DateTime date) => _onMonthDayPressed(context, date),
      onWorkoutPressed: (String workoutId) => _navigateToWorkoutPreview(
        context.read<CalendarDateRangeDataCubit>().userId,
        workoutId,
      ),
      onRacePressed: (String raceId) => _navigateToRacePreview(
        context.read<CalendarDateRangeDataCubit>().userId,
        raceId,
      ),
      onAddWorkout: (DateTime date) => _navigateToWorkoutCreator(
        context.read<CalendarDateRangeDataCubit>().userId,
        date,
      ),
      onAddRace: (DateTime date) => _navigateToRaceCreator(
        context.read<CalendarDateRangeDataCubit>().userId,
        date,
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
    final String userId = context.read<CalendarDateRangeDataCubit>().userId;
    final DayPreviewDialogAction? action =
        await showDialogDependingOnScreenSize(
      DayPreviewDialog(userId: userId, date: date),
    );
    if (action == null) return;
    switch (action) {
      case DayPreviewDialogActionAddWorkout():
        _navigateToWorkoutCreator(userId, action.date);
        break;
      case DayPreviewDialogActionAddRace():
        _navigateToRaceCreator(userId, action.date);
        break;
      case DayPreviewDialogActionShowWorkout():
        _navigateToWorkoutPreview(userId, action.workoutId);
        break;
      case DayPreviewDialogActionShowRace():
        _navigateToRacePreview(userId, action.raceId);
        break;
    }
  }

  void _navigateToWorkoutPreview(String userId, String workoutId) {
    navigateTo(WorkoutPreviewRoute(
      userId: userId,
      workoutId: workoutId,
    ));
  }

  void _navigateToRacePreview(String userId, String raceId) {
    navigateTo(RacePreviewRoute(
      userId: userId,
      raceId: raceId,
    ));
  }

  void _navigateToWorkoutCreator(String userId, DateTime date) {
    navigateTo(WorkoutCreatorRoute(
      userId: userId,
      dateStr: date.toPathFormat(),
    ));
  }

  void _navigateToRaceCreator(String userId, DateTime date) {
    navigateTo(RaceCreatorRoute(
      userId: userId,
      dateStr: date.toPathFormat(),
    ));
  }
}
