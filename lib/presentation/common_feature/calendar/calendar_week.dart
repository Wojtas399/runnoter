import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/calendar_user_data.dart';
import '../../../domain/additional_model/week_day.dart';
import '../../../domain/cubit/calendar/calendar_cubit.dart';
import '../../../domain/cubit/calendar_user_data_cubit.dart';
import '../../component/gap/gap_components.dart';
import '../../component/shimmer/shimmer_container.dart';
import '../../extension/widgets_list_extensions.dart';
import 'calendar_week_day_item.dart';

class CalendarWeek extends StatelessWidget {
  const CalendarWeek({super.key});

  @override
  Widget build(BuildContext context) {
    final CalendarUserData? userData = context.select(
      (CalendarUserDataCubit cubit) => cubit.state,
    );
    final Week? week = context.select(
      (CalendarCubit cubit) => cubit.state.weeks?.isNotEmpty == true
          ? cubit.state.weeks!.first
          : null,
    );

    return Column(
      children: <Widget>[
        if (userData == null || week == null)
          for (int i = 0; i < 7; i++) const _DayItemShimmer(),
        if (userData != null && week != null)
          ...week.days.map(
            (WeekDay day) => CalendarWeekDayItem(
              day: day,
              onPressed: () =>
                  context.read<CalendarCubit>().dayPressed(day.date),
            ),
          ),
      ].addSeparator(const Divider()),
    );
  }
}

class _DayItemShimmer extends StatelessWidget {
  const _DayItemShimmer();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(height: 24, width: 150),
          Gap16(),
          _HealthDataShimmer(),
          Gap16(),
          ShimmerContainer(height: 48, width: double.infinity),
        ],
      ),
    );
  }
}

class _HealthDataShimmer extends StatelessWidget {
  const _HealthDataShimmer();

  @override
  Widget build(BuildContext context) {
    return const IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                ShimmerContainer(height: 14, width: 130),
                Gap8(),
                ShimmerContainer(height: 16, width: 70),
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(
            child: Column(
              children: [
                ShimmerContainer(height: 14, width: 130),
                Gap8(),
                ShimmerContainer(height: 16, width: 70),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
