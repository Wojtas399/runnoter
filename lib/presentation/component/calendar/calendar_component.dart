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
  final Function(DateTime startDate, DateTime endDate)? onDateRangeChanged;
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
  final Function(DateTime startDate, DateTime endDate)? onDateRangeChanged;
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
      final DateTime startDate = state.weeks!.first.days.first.date;
      final DateTime endDate = state.weeks!.last.days.last.date;
      onDateRangeChanged!(startDate, endDate);
    }
  }

  void _emitPressedDay(BuildContext context, DateTime pressedDate) {
    if (onDayPressed != null) {
      onDayPressed!(pressedDate);
    }
  }
}

class _Content extends StatefulWidget {
  final List<Workout> workouts;
  final List<Race> races;
  final Function(String workoutId)? onWorkoutPressed;
  final Function(String raceId)? onRacePressed;
  final Function(DateTime date)? onAddWorkout;
  final Function(DateTime date)? onAddRace;

  const _Content({
    required this.workouts,
    required this.races,
    this.onWorkoutPressed,
    this.onRacePressed,
    this.onAddWorkout,
    this.onAddRace,
  });

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  @override
  void didUpdateWidget(covariant _Content oldWidget) {
    context.read<CalendarComponentBloc>().add(
          CalendarComponentEventActivitiesUpdated(
            workouts: widget.workouts,
            races: widget.races,
          ),
        );
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final DateRange? dateRange = context.select(
      (CalendarComponentBloc bloc) => bloc.state.dateRange,
    );

    return Column(
      children: [
        const CalendarComponentDate(),
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
    if (widget.onWorkoutPressed != null) widget.onWorkoutPressed!(workoutId);
  }

  void _onRacePressed(String raceId) {
    if (widget.onRacePressed != null) widget.onRacePressed!(raceId);
  }

  void _onAddWorkout(DateTime date) {
    if (widget.onAddWorkout != null) widget.onAddWorkout!(date);
  }

  void _onAddRace(DateTime date) {
    if (widget.onAddRace != null) widget.onAddRace!(date);
  }
}
