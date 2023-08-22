import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/calendar_week_day.dart';
import '../../extension/widgets_list_extensions.dart';
import '../week_day_item_component.dart';
import 'bloc/calendar_component_bloc.dart';

class CalendarComponentWeek extends StatelessWidget {
  const CalendarComponentWeek({super.key});

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
            onPressed: () => _onDayPressed(context, day.date),
          ),
        ),
      ].addSeparator(const Divider()),
    );
  }

  void _onDayPressed(BuildContext context, DateTime date) {
    //TODO
  }
}
