import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../gap/gap_components.dart';
import '../gap/gap_horizontal_components.dart';
import 'calendar_component_cubit.dart';
import 'calendar_component_day_labels.dart';
import 'calendar_component_days.dart';
import 'calendar_component_header.dart';

class Calendar extends StatelessWidget {
  final List<CalendarDayActivity> activities;
  final CalendarComponentDateRange? oneRangeType;
  final Function(
    DateTime firstDisplayingDate,
    DateTime lastDisplayingDate,
  )? onMonthChanged;
  final Function(DateTime date)? onDayPressed;

  const Calendar({
    super.key,
    required this.activities,
    this.oneRangeType,
    this.onMonthChanged,
    this.onDayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarComponentCubit(
        dateRange: oneRangeType ?? CalendarComponentDateRange.week,
      ),
      child: _CubitListener(
        onMonthChanged: onMonthChanged,
        onDayPressed: onDayPressed,
        child: _Content(activities: activities, oneRangeType: oneRangeType),
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
  final CalendarComponentDateRange? oneRangeType;

  const _Content({
    required this.activities,
    required this.oneRangeType,
  });

  @override
  Widget build(BuildContext context) {
    context.read<CalendarComponentCubit>().updateState(activities: activities);
    final CalendarComponentDateRange? dateRange = context.select(
      (CalendarComponentCubit cubit) => cubit.state.dateRange,
    );

    return Column(
      children: [
        if (oneRangeType == null) const _DateRange(),
        const Gap8(),
        switch (dateRange) {
          CalendarComponentDateRange.week => const _WeekContent(),
          CalendarComponentDateRange.month => const _MonthContent(),
          null => const CircularProgressIndicator(),
        }
      ],
    );
  }
}

class _WeekContent extends StatelessWidget {
  const _WeekContent();

  @override
  Widget build(BuildContext context) {
    return Text('Week content');
  }
}

class _MonthContent extends StatelessWidget {
  const _MonthContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CalendarComponentHeader(),
        Gap8(),
        CalendarComponentDayLabels(),
        CalendarComponentDays(),
      ],
    );
  }
}

class _DateRange extends StatelessWidget {
  const _DateRange();

  @override
  Widget build(BuildContext context) {
    final CalendarComponentDateRange? dateRange = context.select(
      (CalendarComponentCubit cubit) => cubit.state.dateRange,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _DateRangeButton(
              isSelected: dateRange == CalendarComponentDateRange.week,
              onPressed: () => _onDateRangeChanged(
                context,
                CalendarComponentDateRange.week,
              ),
              label: Str.of(context).week,
            ),
          ),
          const GapHorizontal16(),
          Expanded(
            child: _DateRangeButton(
              isSelected: dateRange == CalendarComponentDateRange.month,
              onPressed: () => _onDateRangeChanged(
                context,
                CalendarComponentDateRange.month,
              ),
              label: Str.of(context).month,
            ),
          ),
        ],
      ),
    );
  }

  void _onDateRangeChanged(
      BuildContext context, CalendarComponentDateRange dateRange) {
    context.read<CalendarComponentCubit>().changeDateRange(dateRange);
  }
}

class _DateRangeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _DateRangeButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? FilledButton(
            onPressed: onPressed,
            child: Text(label),
          )
        : OutlinedButton(
            onPressed: onPressed,
            child: Text(label),
          );
  }
}
