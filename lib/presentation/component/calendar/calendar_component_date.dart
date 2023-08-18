import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/date_service.dart';
import '../../formatter/date_formatter.dart';
import '../gap/gap_components.dart';
import '../gap/gap_horizontal_components.dart';
import '../text/title_text_components.dart';
import 'bloc/calendar_component_bloc.dart';

class CalendarComponentDate extends StatelessWidget {
  const CalendarComponentDate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      constraints: const BoxConstraints(maxWidth: 600),
      child: const Column(
        children: [
          _DateRangeSelection(),
          Gap16(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PreviousDateRangeBtn(),
              _DateRange(),
              _NextDateRangeBtn(),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateRangeSelection extends StatelessWidget {
  const _DateRangeSelection();

  @override
  Widget build(BuildContext context) {
    final DateRange? dateRange = context.select(
      (CalendarComponentBloc bloc) => bloc.state.dateRange,
    );

    return Row(
      children: [
        Expanded(
          child: _DateRangeButton(
            isSelected: dateRange is DateRangeWeek,
            onPressed: () => _onDateRangeChanged(context, DateRangeType.week),
            label: Str.of(context).week,
          ),
        ),
        const GapHorizontal16(),
        Expanded(
          child: _DateRangeButton(
            isSelected: dateRange is DateRangeMonth,
            onPressed: () => _onDateRangeChanged(
              context,
              DateRangeType.month,
            ),
            label: Str.of(context).month,
          ),
        ),
      ],
    );
  }

  void _onDateRangeChanged(BuildContext context, DateRangeType dateRangeType) {
    context.read<CalendarComponentBloc>().add(
          CalendarComponentEventChangeDateRange(dateRangeType: dateRangeType),
        );
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

class _DateRange extends StatelessWidget {
  const _DateRange();

  @override
  Widget build(BuildContext context) {
    final DateRange? dateRange = context.select(
      (CalendarComponentBloc bloc) => bloc.state.dateRange,
    );

    return switch (dateRange) {
      DateRangeWeek() => _Week(dateRange),
      DateRangeMonth() => _Month(dateRange),
      null => const CircularProgressIndicator(),
    };
  }
}

class _Week extends StatelessWidget {
  final DateService _dateService = DateService();
  final DateRangeWeek weekDateRange;

  _Week(this.weekDateRange);

  @override
  Widget build(BuildContext context) {
    final DateTime today = _dateService.getToday();
    final DateTime firstDayOfTheWeek = weekDateRange.firstDayOfTheWeek;
    final DateTime lastDayOfTheWeek = firstDayOfTheWeek.add(
      const Duration(days: 6),
    );
    String text =
        '${firstDayOfTheWeek.toDateWithDots()} - ${lastDayOfTheWeek.toDateWithDots()}';
    if (_dateService.isDateFromRange(
      date: today,
      startDate: firstDayOfTheWeek,
      endDate: lastDayOfTheWeek,
    )) text = Str.of(context).currentWeek;

    return TitleMedium(text);
  }
}

class _Month extends StatelessWidget {
  final DateRangeMonth monthDateRange;

  const _Month(this.monthDateRange);

  @override
  Widget build(BuildContext context) {
    return TitleMedium(
      '${_getMonthName(context, monthDateRange.month)} ${monthDateRange.year}',
    );
  }

  String _getMonthName(BuildContext context, int month) {
    final str = Str.of(context);
    final List<String> monthLabels = [
      str.january,
      str.february,
      str.march,
      str.april,
      str.may,
      str.june,
      str.july,
      str.august,
      str.september,
      str.october,
      str.november,
      str.december,
    ];
    return monthLabels[month - 1];
  }
}

class _PreviousDateRangeBtn extends StatelessWidget {
  const _PreviousDateRangeBtn();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _onPressed(context);
      },
      icon: const Icon(Icons.chevron_left),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<CalendarComponentBloc>().add(
          const CalendarComponentEventPreviousDateRange(),
        );
  }
}

class _NextDateRangeBtn extends StatelessWidget {
  const _NextDateRangeBtn();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _onPressed(context),
      icon: const Icon(Icons.chevron_right),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<CalendarComponentBloc>().add(
          const CalendarComponentEventNextDateRange(),
        );
  }
}
