import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../common/date_service.dart';
import '../../domain/cubit/date_range_manager_cubit.dart';
import '../extension/widgets_list_extensions.dart';
import '../formatter/date_formatter.dart';
import 'gap/gap_components.dart';
import 'gap/gap_horizontal_components.dart';
import 'text/title_text_components.dart';

class DateRangeHeader extends StatelessWidget {
  final DateRangeType selectedDateRangeType;
  final DateRange dateRange;
  final VoidCallback? onWeekSelected;
  final VoidCallback? onMonthSelected;
  final VoidCallback? onYearSelected;
  final VoidCallback? onPreviousRangePressed;
  final VoidCallback? onNextRangePressed;

  const DateRangeHeader({
    super.key,
    required this.selectedDateRangeType,
    required this.dateRange,
    this.onWeekSelected,
    this.onMonthSelected,
    this.onYearSelected,
    this.onPreviousRangePressed,
    this.onNextRangePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        children: [
          _DateRangeTypeSelection(
            selectedDateRangeType: selectedDateRangeType,
            onWeekSelected: onWeekSelected,
            onMonthSelected: onMonthSelected,
            onYearSelected: onYearSelected,
          ),
          if (kIsWeb) const Gap16() else const Gap8(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onPreviousRangePressed,
                icon: const Icon(Icons.chevron_left),
              ),
              _DateRange(
                dateRangeType: selectedDateRangeType,
                dateRange: dateRange,
              ),
              IconButton(
                onPressed: onNextRangePressed,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateRangeTypeSelection extends StatelessWidget {
  final DateRangeType selectedDateRangeType;
  final VoidCallback? onWeekSelected;
  final VoidCallback? onMonthSelected;
  final VoidCallback? onYearSelected;

  const _DateRangeTypeSelection({
    required this.selectedDateRangeType,
    this.onWeekSelected,
    this.onMonthSelected,
    this.onYearSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (onWeekSelected != null)
          Expanded(
            child: _DateRangeButton(
              isSelected: selectedDateRangeType == DateRangeType.week,
              onPressed: _onWeekSelected,
              label: Str.of(context).week,
            ),
          ),
        if (onMonthSelected != null)
          Expanded(
            child: _DateRangeButton(
              isSelected: selectedDateRangeType == DateRangeType.month,
              onPressed: _onMonthSelected,
              label: Str.of(context).month,
            ),
          ),
        if (onYearSelected != null)
          Expanded(
            child: _DateRangeButton(
              isSelected: selectedDateRangeType == DateRangeType.year,
              onPressed: _onYearSelected,
              label: Str.of(context).year,
            ),
          ),
      ].addSeparator(const GapHorizontal16()),
    );
  }

  void _onWeekSelected() {
    if (selectedDateRangeType != DateRangeType.week) onWeekSelected!();
  }

  void _onMonthSelected() {
    if (selectedDateRangeType != DateRangeType.month) onMonthSelected!();
  }

  void _onYearSelected() {
    if (selectedDateRangeType != DateRangeType.year) onYearSelected!();
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
    return SizedBox(
      height: 40,
      child: isSelected
          ? FilledButton(
              onPressed: onPressed,
              child: Text(label),
            )
          : OutlinedButton(
              onPressed: onPressed,
              child: Text(label),
            ),
    );
  }
}

class _DateRange extends StatelessWidget {
  final DateRangeType dateRangeType;
  final DateRange dateRange;

  const _DateRange({
    required this.dateRangeType,
    required this.dateRange,
  });

  @override
  Widget build(BuildContext context) {
    return switch (dateRangeType) {
      DateRangeType.week => _Week(dateRange),
      DateRangeType.month => _Month(
          dateRange.startDate.month,
          dateRange.startDate.year,
        ),
      DateRangeType.year => TitleMedium('${dateRange.startDate.year}'),
    };
  }
}

class _Week extends StatelessWidget {
  final DateService _dateService = DateService();
  final DateRange dateRange;

  _Week(this.dateRange);

  @override
  Widget build(BuildContext context) {
    final DateTime today = _dateService.getToday();
    final DateTime firstDayOfTheWeek = dateRange.startDate;
    final DateTime lastDayOfTheWeek = dateRange.endDate;
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
  final int month;
  final int year;

  const _Month(this.month, this.year);

  @override
  Widget build(BuildContext context) {
    return TitleMedium('${_getMonthName(context, month)} $year');
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
