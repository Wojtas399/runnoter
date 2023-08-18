import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../gap/gap_components.dart';
import 'bloc/calendar_component_bloc.dart';
import 'calendar_component_date.dart';
import 'calendar_component_day_labels.dart';
import 'calendar_component_days.dart';

class Calendar extends StatelessWidget {
  final List<CalendarDayActivity> activities;
  final DateRangeType? dateRangeType;
  final Function(
    DateTime firstDisplayingDate,
    DateTime lastDisplayingDate,
  )? onMonthChanged;
  final Function(DateTime date)? onDayPressed;

  const Calendar({
    super.key,
    required this.activities,
    this.dateRangeType,
    this.onMonthChanged,
    this.onDayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarComponentBloc()
        ..add(
          CalendarComponentEventInitialize(
            dateRangeType: dateRangeType ?? DateRangeType.week,
          ),
        ),
      child: _BlocListener(
        onMonthChanged: onMonthChanged,
        onDayPressed: onDayPressed,
        child: _Content(
          activities: activities,
          showDateRangeButtons: dateRangeType == null,
        ),
      ),
    );
  }
}

class _BlocListener extends StatelessWidget {
  final Function(
    DateTime firstDisplayingDate,
    DateTime lastDisplayingDate,
  )? onMonthChanged;
  final Function(DateTime date)? onDayPressed;
  final Widget child;

  const _BlocListener({
    required this.onMonthChanged,
    required this.onDayPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarComponentBloc, CalendarComponentState>(
      listenWhen: (previousState, currentState) =>
          currentState.pressedDate != null ||
          previousState.weeks == null ||
          previousState.dateRange != currentState.dateRange,
      listener: (_, CalendarComponentState state) {
        if (state.pressedDate != null) {
          _emitPressedDay(context, state.pressedDate!);
        } else {
          _emitNewMonth(state);
        }
      },
      child: child,
    );
  }

  void _emitNewMonth(CalendarComponentState state) {
    if (onMonthChanged != null && state.weeks != null) {
      final DateTime firstDisplayingDate = state.weeks!.first.days.first.date;
      final DateTime lastDisplayingDate = state.weeks!.last.days.last.date;
      onMonthChanged!(firstDisplayingDate, lastDisplayingDate);
    }
  }

  void _emitPressedDay(BuildContext context, DateTime pressedDate) {
    if (onDayPressed != null) {
      onDayPressed!(pressedDate);
    }
  }
}

class _Content extends StatelessWidget {
  final List<CalendarDayActivity>? activities;
  final bool showDateRangeButtons;

  const _Content({
    required this.activities,
    this.showDateRangeButtons = false,
  });

  @override
  Widget build(BuildContext context) {
    if (activities != null) {
      context.read<CalendarComponentBloc>().add(
            CalendarComponentEventActivitiesUpdated(activities: activities!),
          );
    }
    final DateRange? dateRange = context.select(
      (CalendarComponentBloc bloc) => bloc.state.dateRange,
    );

    return Column(
      children: [
        if (showDateRangeButtons) const CalendarComponentDate(),
        const Gap8(),
        switch (dateRange) {
          DateRangeWeek() => const _WeekContent(),
          DateRangeMonth() => const _MonthContent(),
          null => const CircularProgressIndicator(),
        }
      ],
    );
  }
}

class _WeekContent extends StatelessWidget {
  const _WeekContent();

  @override
  Widget build(BuildContext context) {
    return Text('Week content');
  }
}

class _MonthContent extends StatelessWidget {
  const _MonthContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CalendarComponentDayLabels(),
        CalendarComponentDays(),
      ],
    );
  }
}
