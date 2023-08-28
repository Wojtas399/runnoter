import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/chart_date_range_cubit.dart';
import '../date_range_header_component.dart';
import 'bloc/calendar_component_bloc.dart';

class CalendarComponentDate extends StatelessWidget {
  const CalendarComponentDate({super.key});

  @override
  Widget build(BuildContext context) {
    final DateRangeType dateRangeType = context.select(
      (CalendarComponentBloc bloc) => bloc.state.dateRangeType,
    );
    final DateRange? dateRange = context.select(
      (CalendarComponentBloc bloc) => bloc.state.dateRange,
    );

    return dateRange != null
        ? DateRangeHeader(
            selectedDateRangeType: dateRangeType,
            dateRange: dateRange,
            onWeekSelected: () =>
                _onDateRangeTypeChanged(context, DateRangeType.week),
            onMonthSelected: () =>
                _onDateRangeTypeChanged(context, DateRangeType.month),
            onPreviousRangePressed: () => _onPreviousDateRange(context),
            onNextRangePressed: () => _onNextDateRange(context),
          )
        : const SizedBox();
  }

  void _onDateRangeTypeChanged(
    BuildContext context,
    DateRangeType dateRangeType,
  ) {
    context.read<CalendarComponentBloc>().add(
          CalendarComponentEventChangeDateRangeType(
              dateRangeType: dateRangeType),
        );
  }

  void _onPreviousDateRange(BuildContext context) {
    context
        .read<CalendarComponentBloc>()
        .add(const CalendarComponentEventPreviousDateRange());
  }

  void _onNextDateRange(BuildContext context) {
    context
        .read<CalendarComponentBloc>()
        .add(const CalendarComponentEventNextDateRange());
  }
}
