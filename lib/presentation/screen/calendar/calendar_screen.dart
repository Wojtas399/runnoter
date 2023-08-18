import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/calendar_cubit.dart';
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
              tabletBody: CardBody(child: _Calendar()),
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
    final CalendarState state = context.select(
      (CalendarCubit cubit) => cubit.state,
    );

    return Calendar(
      dateRangeType: DateRangeType.month,
      workouts: [...?state.workouts],
      races: [...?state.races],
      onDateRangeChanged: (DateTime firstDay, DateTime lastDay) =>
          _onDateRangeChanged(context, firstDay, lastDay),
      onDayPressed: (DateTime date) => _onDayPressed(context, date),
    );
  }

  void _onDateRangeChanged(
    BuildContext context,
    DateTime firstDay,
    DateTime lastDay,
  ) {
    context.read<CalendarCubit>().monthChanged(
          firstDay: firstDay,
          lastDay: lastDay,
        );
  }

  Future<void> _onDayPressed(BuildContext context, DateTime date) async {
    final DayPreviewDialogAction? action =
        await showDialogDependingOnScreenSize(DayPreviewDialog(date: date));
    if (action == null) return;
    switch (action) {
      case DayPreviewDialogActionAddWorkout():
        navigateTo(
          WorkoutCreatorRoute(date: action.date.toPathFormat()),
        );
        break;
      case DayPreviewDialogActionAddRace():
        navigateTo(
          RaceCreatorRoute(dateStr: action.date.toPathFormat()),
        );
        break;
      case DayPreviewDialogActionShowWorkout():
        navigateTo(
          WorkoutPreviewRoute(workoutId: action.workoutId),
        );
        break;
      case DayPreviewDialogActionShowRace():
        navigateTo(
          RacePreviewRoute(raceId: action.raceId),
        );
        break;
    }
  }
}
