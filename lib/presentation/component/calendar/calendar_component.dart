import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/calendar_user_data.dart';
import '../../../domain/bloc/calendar/calendar_bloc.dart';
import '../../../domain/cubit/date_range_manager_cubit.dart';
import '../gap/gap_components.dart';
import 'calendar_component__month.dart';
import 'calendar_component_date.dart';
import 'calendar_component_week.dart';

class CalendarComponent extends StatelessWidget {
  final DateRangeType? dateRangeType;
  final CalendarUserData? calendarUserData;
  final Function(DateTime date)? onDayPressed;
  final Function(DateTime startDate, DateTime endDate) onDateRangeChanged;

  const CalendarComponent({
    super.key,
    this.dateRangeType,
    this.calendarUserData,
    required this.onDayPressed,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CalendarBloc, CalendarState>(
          listenWhen: (previousState, currentState) =>
              previousState.dateRange != currentState.dateRange &&
              currentState.weeks != null,
          listener: _emitNewDateRange,
        ),
        BlocListener<CalendarBloc, CalendarState>(
          listenWhen: (previousState, currentState) =>
              currentState.pressedDay != null,
          listener: _emitPressedDay,
        ),
      ],
      child: _Content(calendarUserData: calendarUserData),
    );
  }

  void _emitNewDateRange(BuildContext context, CalendarState state) {
    final DateTime startDate = state.weeks!.first.days.first.date;
    final DateTime endDate = state.weeks!.last.days.last.date;
    onDateRangeChanged(startDate, endDate);
  }

  void _emitPressedDay(BuildContext context, CalendarState state) {
    if (onDayPressed != null) onDayPressed!(state.pressedDay!);
    context.read<CalendarBloc>().add(
          const CalendarEventResetPressedDay(),
        );
  }
}

class _Content extends StatefulWidget {
  final CalendarUserData? calendarUserData;

  const _Content({this.calendarUserData});

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  @override
  void didUpdateWidget(covariant _Content oldWidget) {
    if (widget.calendarUserData != null) {
      context.read<CalendarBloc>().add(
            CalendarEventUserDataUpdated(
              userData: widget.calendarUserData!,
            ),
          );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final DateRangeType? dateRangeType = context.select(
      (CalendarBloc bloc) => bloc.state.dateRangeType,
    );

    return Column(
      children: [
        const CalendarComponentDate(),
        const Gap8(),
        if (dateRangeType == DateRangeType.week)
          const CalendarComponentWeek()
        else if (dateRangeType == DateRangeType.month)
          const CalendarComponentMonth(),
      ],
    );
  }
}
