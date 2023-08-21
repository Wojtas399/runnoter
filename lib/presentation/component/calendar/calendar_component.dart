import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/calendar_date_range_data.dart';
import '../body/big_body_component.dart';
import '../card_body_component.dart';
import '../gap/gap_components.dart';
import '../padding/paddings_24.dart';
import '../responsive_layout_component.dart';
import 'bloc/calendar_component_bloc.dart';
import 'calendar_component__month.dart';
import 'calendar_component_date.dart';
import 'calendar_component_week.dart';

class CalendarComponent extends StatelessWidget {
  final DateRangeType? dateRangeType;
  final CalendarDateRangeData dateRangeData;
  final Function(String workoutId) onWorkoutPressed;
  final Function(String raceId) onRacePressed;
  final Function(DateTime date) onAddWorkout;
  final Function(DateTime date) onAddRace;
  final Function(DateTime date) onMonthDayPressed;
  final Function(DateTime startDate, DateTime endDate) onDateRangeChanged;

  const CalendarComponent({
    super.key,
    this.dateRangeType,
    required this.dateRangeData,
    required this.onWorkoutPressed,
    required this.onRacePressed,
    required this.onAddWorkout,
    required this.onAddRace,
    required this.onMonthDayPressed,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarComponentBloc()
        ..add(CalendarComponentEventInitialize(
          dateRangeType: dateRangeType ?? DateRangeType.week,
        )),
      child: _BlocListener(
        onDateRangeChanged: onDateRangeChanged,
        child: _Content(
          dateRangeData: dateRangeData,
          onWorkoutPressed: onWorkoutPressed,
          onRacePressed: onRacePressed,
          onMonthDayPressed: onMonthDayPressed,
          onAddWorkout: onAddWorkout,
          onAddRace: onAddRace,
        ),
      ),
    );
  }
}

class _BlocListener extends StatelessWidget {
  final Function(DateTime startDate, DateTime endDate) onDateRangeChanged;
  final Widget child;

  const _BlocListener({required this.onDateRangeChanged, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarComponentBloc, CalendarComponentState>(
      listenWhen: (previousState, currentState) =>
          previousState.weeks == null ||
          previousState.dateRange != currentState.dateRange,
      listener: (_, CalendarComponentState state) {
        _emitNewDateRange(state);
      },
      child: child,
    );
  }

  void _emitNewDateRange(CalendarComponentState state) {
    if (state.weeks != null) {
      final DateTime startDate = state.weeks!.first.days.first.date;
      final DateTime endDate = state.weeks!.last.days.last.date;
      onDateRangeChanged(startDate, endDate);
    }
  }
}

class _Content extends StatefulWidget {
  final CalendarDateRangeData dateRangeData;
  final Function(String workoutId) onWorkoutPressed;
  final Function(String raceId) onRacePressed;
  final Function(DateTime date) onAddWorkout;
  final Function(DateTime date) onAddRace;
  final Function(DateTime date) onMonthDayPressed;

  const _Content({
    required this.dateRangeData,
    required this.onWorkoutPressed,
    required this.onRacePressed,
    required this.onAddWorkout,
    required this.onAddRace,
    required this.onMonthDayPressed,
  });

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  @override
  void didUpdateWidget(covariant _Content oldWidget) {
    context.read<CalendarComponentBloc>().add(
          CalendarComponentEventDateRangeDataUpdated(
              data: widget.dateRangeData),
        );
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BigBody(
        child: Paddings24(
          child: ResponsiveLayout(
            mobileBody: _Calendar(
              onWorkoutPressed: widget.onWorkoutPressed,
              onRacePressed: widget.onRacePressed,
              onMonthDayPressed: widget.onMonthDayPressed,
              onAddWorkout: widget.onAddWorkout,
              onAddRace: widget.onAddRace,
            ),
            desktopBody: CardBody(
              child: _Calendar(
                onWorkoutPressed: widget.onWorkoutPressed,
                onRacePressed: widget.onRacePressed,
                onMonthDayPressed: widget.onMonthDayPressed,
                onAddWorkout: widget.onAddWorkout,
                onAddRace: widget.onAddRace,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Calendar extends StatelessWidget {
  final Function(String workoutId) onWorkoutPressed;
  final Function(String raceId) onRacePressed;
  final Function(DateTime date) onAddWorkout;
  final Function(DateTime date) onAddRace;
  final Function(DateTime date) onMonthDayPressed;

  const _Calendar({
    required this.onWorkoutPressed,
    required this.onRacePressed,
    required this.onAddWorkout,
    required this.onAddRace,
    required this.onMonthDayPressed,
  });

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
              onWorkoutPressed: onWorkoutPressed,
              onRacePressed: onRacePressed,
              onAddWorkout: onAddWorkout,
              onAddRace: onAddRace,
            ),
          DateRangeMonth() => CalendarComponentMonth(
              onMonthDayPressed: onMonthDayPressed,
            ),
          null => const CircularProgressIndicator(),
        }
      ],
    );
  }
}
