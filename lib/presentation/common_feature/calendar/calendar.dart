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
  final CalendarDateRangeType initialDateRangeType;
  final bool canEditHealthMeasurement;

  const Calendar({
    super.key,
    required this.userId,
    this.initialDateRangeType = CalendarDateRangeType.month,
    this.canEditHealthMeasurement = true,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CalendarDateRangeDataCubit(userId: userId)),
        BlocProvider(
          create: (_) => CalendarComponentBloc()
            ..add(CalendarComponentEventInitialize(
              dateRangeType: initialDateRangeType,
            )),
        ),
      ],
      child: SingleChildScrollView(
        child: BigBody(
          child: Paddings24(
            child: ResponsiveLayout(
              mobileBody: _Calendar(
                canEditHealthMeasurement: canEditHealthMeasurement,
              ),
              desktopBody: CardBody(
                child: _Calendar(
                  canEditHealthMeasurement: canEditHealthMeasurement,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Calendar extends StatelessWidget {
  final bool canEditHealthMeasurement;

  const _Calendar({required this.canEditHealthMeasurement});

  @override
  Widget build(BuildContext context) {
    final CalendarDateRangeData dateRangeData = context.select(
      (CalendarDateRangeDataCubit cubit) => cubit.state,
    );

    return CalendarComponent(
      dateRangeType: CalendarDateRangeType.month,
      dateRangeData: dateRangeData,
      onDateRangeChanged: (DateTime startDate, DateTime endDate) =>
          _onDateRangeChanged(context, startDate, endDate),
      onDayPressed: (DateTime date) => _onDayPressed(context, date),
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

  Future<void> _onDayPressed(BuildContext context, DateTime date) async {
    final String userId = context.read<CalendarDateRangeDataCubit>().userId;
    final DayPreviewDialogAction? action =
        await showDialogDependingOnScreenSize(
      DayPreviewDialog(userId: userId, date: date),
    );
    if (action == null) return;
    switch (action) {
      case DayPreviewDialogActionAddWorkout():
        navigateTo(WorkoutCreatorRoute(
          userId: userId,
          dateStr: action.date.toPathFormat(),
        ));
        break;
      case DayPreviewDialogActionAddRace():
        navigateTo(RaceCreatorRoute(
          userId: userId,
          dateStr: action.date.toPathFormat(),
        ));
        break;
      case DayPreviewDialogActionShowWorkout():
        navigateTo(
          WorkoutPreviewRoute(userId: userId, workoutId: action.workoutId),
        );
        break;
      case DayPreviewDialogActionShowRace():
        navigateTo(RacePreviewRoute(userId: userId, raceId: action.raceId));
        break;
    }
  }
}
