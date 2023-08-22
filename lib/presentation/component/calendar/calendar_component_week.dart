import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/calendar_week_day.dart';
import '../../extension/widgets_list_extensions.dart';
import '../week_day_item_component.dart';
import 'bloc/calendar_component_bloc.dart';

class CalendarComponentWeek extends StatelessWidget {
  final Function(String workoutId) onWorkoutPressed;
  final Function(String raceId) onRacePressed;
  final Function(DateTime date)? onEditHealthMeasurement;
  final Function(DateTime date)? onAddWorkout;
  final Function(DateTime date)? onAddRace;

  const CalendarComponentWeek({
    super.key,
    required this.onWorkoutPressed,
    required this.onRacePressed,
    this.onEditHealthMeasurement,
    this.onAddWorkout,
    this.onAddRace,
  });

  @override
  Widget build(BuildContext context) {
    final CalendarWeek? week = context.select(
      (CalendarComponentBloc bloc) =>
          bloc.state.weeks?.isNotEmpty == true ? bloc.state.weeks!.first : null,
    );

    return Column(
      children: <Widget>[
        ...?week?.days.map(
          (CalendarWeekDay day) => WeekDayItem(
            day: day,
            onWorkoutPressed: onWorkoutPressed,
            onRacePressed: onRacePressed,
            onEditHealthMeasurement: onEditHealthMeasurement != null
                ? () => onEditHealthMeasurement!(day.date)
                : null,
            onAddWorkout:
                onAddWorkout != null ? () => onAddWorkout!(day.date) : null,
            onAddRace: onAddRace != null ? () => onAddRace!(day.date) : null,
          ),
        ),
      ].addSeparator(const Divider()),
    );
  }
}
