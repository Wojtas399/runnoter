import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/date_service.dart';
import 'calendar_component_cubit.dart';

part 'calendar_component_day_labels.dart';
part 'calendar_component_days.dart';
part 'calendar_component_header.dart';

class Calendar extends StatelessWidget {
  final DateTime initialDate;
  final List<WorkoutDay> workoutDays;

  const Calendar({
    super.key,
    required this.initialDate,
    required this.workoutDays,
  });

  @override
  Widget build(BuildContext context) {
    return _CubitProvider(
      initialDate: initialDate,
      workoutDays: workoutDays,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _Header(),
          SizedBox(height: 8),
          _DayLabels(),
          _Days(),
        ],
      ),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final DateTime initialDate;
  final List<WorkoutDay> workoutDays;
  final Widget child;

  const _CubitProvider({
    required this.initialDate,
    required this.workoutDays,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarComponentCubit(
        dateService: DateService(),
      )..initialize(
          initialDate: initialDate,
          workoutDays: workoutDays,
        ),
      child: child,
    );
  }
}
