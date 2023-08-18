import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/race.dart';
import '../../../domain/entity/workout.dart';
import '../gap/gap_components.dart';
import 'bloc/calendar_component_bloc.dart';
import 'calendar_component__month.dart';
import 'calendar_component_date.dart';
import 'calendar_component_week.dart';

class Calendar extends StatelessWidget {
  final List<Workout> workouts;
  final List<Race> races;
  final DateRangeType? dateRangeType;
  final Function(
    DateTime firstDisplayingDate,
    DateTime lastDisplayingDate,
  )? onMonthChanged;
  final Function(DateTime date)? onDayPressed;

  const Calendar({
    super.key,
    required this.workouts,
    required this.races,
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
          workouts: workouts,
          races: races,
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
  final List<Workout> workouts;
  final List<Race> races;
  final bool showDateRangeButtons;

  const _Content({
    required this.workouts,
    required this.races,
    this.showDateRangeButtons = false,
  });

  @override
  Widget build(BuildContext context) {
    context.read<CalendarComponentBloc>().add(
          CalendarComponentEventActivitiesUpdated(
            workouts: workouts,
            races: races,
          ),
        );
    final DateRange? dateRange = context.select(
      (CalendarComponentBloc bloc) => bloc.state.dateRange,
    );

    return Column(
      children: [
        if (showDateRangeButtons) const CalendarComponentDate(),
        const Gap8(),
        switch (dateRange) {
          DateRangeWeek() => const CalendarComponentWeek(),
          DateRangeMonth() => const CalendarComponentMonth(),
          null => const CircularProgressIndicator(),
        }
      ],
    );
  }
}
