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
  final Function(
    DateTime firstDisplayingDate,
    DateTime lastDisplayingDate,
  )? onMonthChanged;

  const Calendar({
    super.key,
    required this.initialDate,
    required this.workoutDays,
    this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _CubitProvider(
      initialDate: initialDate,
      workoutDays: workoutDays,
      child: _CubitListener(
        onMonthChanged: onMonthChanged,
        child: _Content(
          workoutDays: workoutDays,
        ),
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
      )..updateState(
          date: initialDate,
        ),
      child: child,
    );
  }
}

class _CubitListener extends StatelessWidget {
  final Function(
    DateTime firstDisplayingDate,
    DateTime lastDisplayingDate,
  )? onMonthChanged;
  final Widget child;

  const _CubitListener({
    required this.onMonthChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarComponentCubit, CalendarComponentState>(
      listenWhen: (previousState, currentState) =>
          previousState.displayingMonth != currentState.displayingMonth ||
          previousState.displayingYear != currentState.displayingYear,
      listener: (_, CalendarComponentState state) {
        _emitNewMonth(state);
      },
      child: child,
    );
  }

  void _emitNewMonth(CalendarComponentState state) {
    if (onMonthChanged != null && state.weeks != null) {
      final DateTime firstDisplayingDate = state.weeks!.first.days.first.date;
      final DateTime lastDisplayingDate = state.weeks!.last.days.last.date;
      onMonthChanged!(firstDisplayingDate, lastDisplayingDate);
    }
  }
}

class _Content extends StatelessWidget {
  final List<WorkoutDay>? workoutDays;

  const _Content({
    required this.workoutDays,
  });

  @override
  Widget build(BuildContext context) {
    context.read<CalendarComponentCubit>().updateState(
          workoutDays: workoutDays,
        );

    return Column(
      children: const [
        _Header(),
        SizedBox(height: 8),
        _DayLabels(),
        _Days(),
      ],
    );
  }
}
