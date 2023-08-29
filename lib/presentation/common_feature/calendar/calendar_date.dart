import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/calendar/calendar_bloc.dart';
import '../../../domain/cubit/date_range_manager_cubit.dart';
import '../../component/date_range_header_component.dart';

class CalendarDate extends StatelessWidget {
  const CalendarDate({super.key});

  @override
  Widget build(BuildContext context) {
    final DateRangeType dateRangeType = context.select(
      (CalendarBloc bloc) => bloc.state.dateRangeType,
    );
    final DateRange? dateRange = context.select(
      (CalendarBloc bloc) => bloc.state.dateRange,
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
    context.read<CalendarBloc>().add(
          CalendarEventChangeDateRangeType(dateRangeType: dateRangeType),
        );
  }

  void _onPreviousDateRange(BuildContext context) {
    context.read<CalendarBloc>().add(const CalendarEventPreviousDateRange());
  }

  void _onNextDateRange(BuildContext context) {
    context.read<CalendarBloc>().add(const CalendarEventNextDateRange());
  }
}
