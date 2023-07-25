import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../text/body_text_components.dart';
import 'calendar_component_cubit.dart';

part 'calendar_component_day_labels.dart';
part 'calendar_component_days.dart';
part 'calendar_component_header.dart';

class Calendar extends StatelessWidget {
  final List<CalendarDayActivity> activities;
  final Function(
    DateTime firstDisplayingDate,
    DateTime lastDisplayingDate,
  )? onMonthChanged;
  final Function(DateTime date)? onDayPressed;

  const Calendar({
    super.key,
    required this.activities,
    this.onMonthChanged,
    this.onDayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarComponentCubit(),
      child: _CubitListener(
        onMonthChanged: onMonthChanged,
        onDayPressed: onDayPressed,
        child: _Content(activities: activities),
      ),
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
          _emitPressedDay(context, state.pressedDate!);
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

  void _emitPressedDay(BuildContext context, DateTime pressedDate) {
    if (onDayPressed != null) {
      onDayPressed!(pressedDate);
      context.read<CalendarComponentCubit>().cleanPressedDay();
    }
  }
}

class _Content extends StatelessWidget {
  final List<CalendarDayActivity>? activities;

  const _Content({
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    context.read<CalendarComponentCubit>().updateState(activities: activities);

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
