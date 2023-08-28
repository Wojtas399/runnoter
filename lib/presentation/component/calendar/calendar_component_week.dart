import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/calendar_week_day.dart';
import '../../extension/widgets_list_extensions.dart';
import '../gap/gap_components.dart';
import '../shimmer/shimmer_container.dart';
import '../week_day_item_component.dart';
import 'bloc/calendar_component_bloc.dart';

class CalendarComponentWeek extends StatelessWidget {
  const CalendarComponentWeek({super.key});

  @override
  Widget build(BuildContext context) {
    final bool areUserDataLoaded = context.select(
      (CalendarComponentBloc bloc) => bloc.state.areUserDataLoaded,
    );
    final CalendarWeek? week = context.select(
      (CalendarComponentBloc bloc) =>
          bloc.state.weeks?.isNotEmpty == true ? bloc.state.weeks!.first : null,
    );

    return Column(
      children: <Widget>[
        if (areUserDataLoaded == false || week == null)
          for (int i = 0; i < 7; i++) const _DayItemShimmer(),
        if (areUserDataLoaded && week != null)
          ...week.days.map(
            (CalendarWeekDay day) => WeekDayItem(
              day: day,
              onPressed: () => _onDayPressed(context, day.date),
            ),
          ),
      ].addSeparator(const Divider()),
    );
  }

  void _onDayPressed(BuildContext context, DateTime date) {
    context.read<CalendarComponentBloc>().add(
          CalendarComponentEventDayPressed(date: date),
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
