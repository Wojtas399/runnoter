import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/calendar_user_data.dart';
import '../../../domain/bloc/calendar/calendar_bloc.dart';
import '../../../domain/cubit/current_week_cubit.dart';
import '../../../domain/cubit/date_range_manager_cubit.dart';
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
          create: (_) => CalendarBloc()
            ..add(
              const CalendarEventInitialize(dateRangeType: DateRangeType.week),
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
    return BlocListener<CurrentWeekCubit, CalendarUserData?>(
      listener: (BuildContext context, CalendarUserData? calendarUserData) {
        if (calendarUserData != null) {
          context.read<CalendarBloc>().add(
                CalendarEventUserDataUpdated(userData: calendarUserData),
              );
        }
      },
      child: child,
    );
  }
}
