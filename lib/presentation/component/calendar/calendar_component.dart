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
  final Function(DateTime firstDay, DateTime lastDay)? onDateRangeChanged;
  final Function(String workoutId)? onWorkoutPressed;
  final Function(String raceId)? onRacePressed;
  final Function(DateTime date)? onAddWorkout;
  final Function(DateTime date)? onAddRace;
  final Function(DateTime date)? onDayPressed;

  const Calendar({
    super.key,
    required this.workouts,
    required this.races,
    this.dateRangeType,
    this.onDateRangeChanged,
    this.onWorkoutPressed,
    this.onRacePressed,
    this.onAddWorkout,
    this.onAddRace,
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
        onDateRangeChanged: onDateRangeChanged,
        onDayPressed: onDayPressed,
        child: _Content(
          workouts: workouts,
          races: races,
          showDateRangeTypeButtons: dateRangeType == null,
          onWorkoutPressed: onWorkoutPressed,
          onRacePressed: onRacePressed,
          onAddWorkout: onAddWorkout,
          onAddRace: onAddRace,
        ),
      ),
    );
  }
}

class _BlocListener extends StatelessWidget {
  final Function(DateTime firstDay, DateTime latDay)? onDateRangeChanged;
  final Function(DateTime date)? onDayPressed;
  final Widget child;

  const _BlocListener({
    required this.onDateRangeChanged,
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
          _emitNewDateRange(state);
        }
      },
      child: child,
    );
  }

  void _emitNewDateRange(CalendarComponentState state) {
    if (onDateRangeChanged != null && state.weeks != null) {
      final DateTime firstDay = state.weeks!.first.days.first.date;
      final DateTime lastDay = state.weeks!.last.days.last.date;
      onDateRangeChanged!(firstDay, lastDay);
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
  final bool showDateRangeTypeButtons;
  final Function(String workoutId)? onWorkoutPressed;
  final Function(String raceId)? onRacePressed;
  final Function(DateTime date)? onAddWorkout;
  final Function(DateTime date)? onAddRace;

  const _Content({
    required this.workouts,
    required this.races,
    this.showDateRangeTypeButtons = false,
    this.onWorkoutPressed,
    this.onRacePressed,
    this.onAddWorkout,
    this.onAddRace,
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
        CalendarComponentDate(
          showDateRangeTypeButtons: showDateRangeTypeButtons,
        ),
        const Gap8(),
        switch (dateRange) {
          DateRangeWeek() => CalendarComponentWeek(
              onWorkoutPressed: _onWorkoutPressed,
              onRacePressed: _onRacePressed,
              onAddWorkout: _onAddWorkout,
              onAddRace: _onAddRace,
            ),
          DateRangeMonth() => const CalendarComponentMonth(),
          null => const CircularProgressIndicator(),
        }
      ],
    );
  }

  void _onWorkoutPressed(String workoutId) {
    if (onWorkoutPressed != null) onWorkoutPressed!(workoutId);
  }

  void _onRacePressed(String raceId) {
    if (onRacePressed != null) onRacePressed!(raceId);
  }

  void _onAddWorkout(DateTime date) {
    if (onAddWorkout != null) onAddWorkout!(date);
  }

  void _onAddRace(DateTime date) {
    if (onAddRace != null) onAddRace!(date);
  }
}
