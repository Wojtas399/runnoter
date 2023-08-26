import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/calendar_date_range_data.dart';
import '../../../domain/cubit/current_week_cubit.dart';
import '../../component/calendar/bloc/calendar_component_bloc.dart';
import 'current_week_content.dart';

@RoutePage()
class CurrentWeekScreen extends StatelessWidget {
  const CurrentWeekScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CurrentWeekCubit()..initialize()),
        BlocProvider(
          create: (_) => CalendarComponentBloc()
            ..add(
              const CalendarComponentEventInitialize(
                dateRangeType: CalendarDateRangeType.week,
              ),
            ),
        ),
      ],
      child: const _CurrentWeekCubitListener(
        child: CurrentWeekContent(),
      ),
    );
  }
}

class _CurrentWeekCubitListener extends StatelessWidget {
  final Widget child;

  const _CurrentWeekCubitListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrentWeekCubit, CalendarDateRangeData?>(
      listener: (BuildContext context, CalendarDateRangeData? dateRangeData) {
        if (dateRangeData != null) {
          context.read<CalendarComponentBloc>().add(
                CalendarComponentEventDateRangeDataUpdated(data: dateRangeData),
              );
        }
      },
      child: child,
    );
  }
}
