import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/calendar_date_range_data_cubit.dart';
import '../../component/calendar/calendar_component.dart';

class Calendar extends StatelessWidget {
  final String userId;

  const Calendar({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarDateRangeDataCubit(userId: userId),
      child: Builder(
        builder: (context) {
          return CalendarComponent(
            onDateRangeChanged: (DateTime startDate, DateTime endDate) =>
                _onDateRangeChanged(context, startDate, endDate),
          );
        },
      ),
    );
  }

  void _onDateRangeChanged(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
  ) {
    context.read<CalendarDateRangeDataCubit>().dateRangeChanged(
          startDate: startDate,
          endDate: endDate,
        );
  }
}
