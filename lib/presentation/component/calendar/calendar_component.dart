import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/calendar_user_data.dart';
import '../gap/gap_components.dart';
import 'bloc/calendar_component_bloc.dart';
import 'calendar_component__month.dart';
import 'calendar_component_date.dart';
import 'calendar_component_week.dart';

class CalendarComponent extends StatelessWidget {
  final CalendarDateRangeType? dateRangeType;
  final CalendarUserData calendarUserData;
  final Function(DateTime date)? onDayPressed;
  final Function(DateTime startDate, DateTime endDate) onDateRangeChanged;

  const CalendarComponent({
    super.key,
    this.dateRangeType,
    required this.calendarUserData,
    required this.onDayPressed,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CalendarComponentBloc, CalendarComponentState>(
          listenWhen: (previousState, currentState) =>
              previousState.dateRange != currentState.dateRange &&
              currentState.weeks != null,
          listener: _emitNewDateRange,
        ),
        BlocListener<CalendarComponentBloc, CalendarComponentState>(
          listenWhen: (previousState, currentState) =>
              currentState.pressedDay != null,
          listener: _emitPressedDay,
        ),
      ],
      child: _Content(calendarUserData: calendarUserData),
    );
  }

  void _emitNewDateRange(BuildContext context, CalendarComponentState state) {
    final DateTime startDate = state.weeks!.first.days.first.date;
    final DateTime endDate = state.weeks!.last.days.last.date;
    onDateRangeChanged(startDate, endDate);
  }

  void _emitPressedDay(BuildContext context, CalendarComponentState state) {
    if (onDayPressed != null) onDayPressed!(state.pressedDay!);
    context.read<CalendarComponentBloc>().add(
          const CalendarComponentEventResetPressedDay(),
        );
  }
}

class _Content extends StatefulWidget {
  final CalendarUserData calendarUserData;

  const _Content({required this.calendarUserData});

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  @override
  void didUpdateWidget(covariant _Content oldWidget) {
    context.read<CalendarComponentBloc>().add(
          CalendarComponentEventDateRangeDataUpdated(
            data: widget.calendarUserData,
          ),
        );
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final CalendarDateRange? dateRange = context.select(
      (CalendarComponentBloc bloc) => bloc.state.dateRange,
    );

    return Column(
      children: [
        const CalendarComponentDate(),
        const Gap8(),
        switch (dateRange) {
          CalendarDateRangeWeek() => const CalendarComponentWeek(),
          CalendarDateRangeMonth() => const CalendarComponentMonth(),
          null => const CircularProgressIndicator(),
        }
      ],
    );
  }
}
