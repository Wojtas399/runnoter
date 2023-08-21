import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        ...?week?.days.map((day) => WeekDayItem(day: day)),
      ].addSeparator(const Divider()),
    );
  }
}
