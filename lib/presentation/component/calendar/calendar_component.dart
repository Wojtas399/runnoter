import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/date_service.dart';
import 'calendar_component_cubit.dart';

part 'calendar_component_day_labels.dart';
part 'calendar_component_days.dart';
part 'calendar_component_header.dart';

class Calendar extends StatelessWidget {
  final List<WorkoutDay> workoutDays;
  final Function(
    DateTime firstDisplayingDate,
    DateTime lastDisplayingDate,
  )? onMonthChanged;
  final Function(DateTime date)? onDayPressed;

  const Calendar({
    super.key,
    required this.workoutDays,
    this.onMonthChanged,
    this.onDayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _CubitProvider(
      child: _CubitListener(
        onMonthChanged: onMonthChanged,
        onDayPressed: onDayPressed,
        child: _Content(
          workoutDays: workoutDays,
        ),
      ),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final Widget child;

  const _CubitProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarComponentCubit(
        dateService: DateService(),
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
  final Function(DateTime date)? onDayPressed;
  final Widget child;

  const _CubitListener({
    required this.onMonthChanged,
    required this.onDayPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarComponentCubit, CalendarComponentState>(
      listenWhen: (previousState, currentState) =>
          currentState.pressedDate != null ||
          previousState.weeks == null ||
          previousState.displayingMonth != currentState.displayingMonth ||
          previousState.displayingYear != currentState.displayingYear,
      listener: (_, CalendarComponentState state) {
        if (state.pressedDate != null) {
          _emitPressedDay(state.pressedDate!);
        } else {
          _emitNewMonth(state);
        }
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

  void _emitPressedDay(DateTime pressedDate) {
    if (onDayPressed != null) {
      onDayPressed!(pressedDate);
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

    return const Column(
      children: [
        _Header(),
        SizedBox(height: 8),
        _DayLabels(),
        _Days(),
      ],
    );
  }
}
