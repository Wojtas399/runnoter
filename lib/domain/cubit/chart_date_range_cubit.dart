import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/date_service.dart';
import '../../dependency_injection.dart';

class ChartDateRangeCubit extends Cubit<ChartDateRangeState> {
  final DateService _dateService;

  ChartDateRangeCubit({
    ChartDateRangeState initialState = const ChartDateRangeState(
      dateRangeType: DateRangeType.week,
    ),
  })  : _dateService = getIt<DateService>(),
        super(initialState);

  void initializeNewDateRangeType(DateRangeType dateRangeType) {
    final DateTime today = _dateService.getToday();
    final DateRange newDateRange = switch (dateRangeType) {
      DateRangeType.week => DateRange(
          startDate: _dateService.getFirstDayOfTheWeek(today),
          endDate: _dateService.getLastDayOfTheWeek(today),
        ),
      DateRangeType.month => DateRange(
          startDate:
              _dateService.getFirstDayOfTheMonth(today.month, today.year),
          endDate: _dateService.getLastDayOfTheMonth(today.month, today.year),
        ),
      DateRangeType.year => DateRange(
          startDate: _dateService.getFirstDayOfTheYear(today.year),
          endDate: _dateService.getLastDayOfTheYear(today.year),
        ),
    };
    emit(state.copyWith(
      dateRangeType: dateRangeType,
      dateRange: newDateRange,
    ));
  }

  void nextDateRange() {
    final DateRange? currentDateRange = state.dateRange;
    if (currentDateRange == null) return;
    final DateRange newDateRange = switch (state.dateRangeType) {
      DateRangeType.week => _calculateDateRangeOfNextWeek(),
      DateRangeType.month => _calculateDateRangeOfNextMonth(),
      DateRangeType.year => _calculateDateRangeOfNextYear(),
    };
    emit(state.copyWith(dateRange: newDateRange));
  }

  void previousDateRange() {
    final DateRange? currentDateRange = state.dateRange;
    if (currentDateRange == null) return;
    final DateRange newDateRange = switch (state.dateRangeType) {
      DateRangeType.week => _calculateDateRangeOfPreviousWeek(),
      DateRangeType.month => _calculateDateRangeOfPreviousMonth(),
      DateRangeType.year => _calculateDateRangeOfPreviousYear(),
    };
    emit(state.copyWith(dateRange: newDateRange));
  }

  DateRange _calculateDateRangeOfNextWeek() {
    final DateRange currentDateRange = state.dateRange!;
    return DateRange(
      startDate: currentDateRange.startDate.add(const Duration(days: 7)),
      endDate: currentDateRange.endDate.add(const Duration(days: 7)),
    );
  }

  DateRange _calculateDateRangeOfPreviousWeek() {
    final DateRange currentDateRange = state.dateRange!;
    return DateRange(
      startDate: currentDateRange.startDate.subtract(const Duration(days: 7)),
      endDate: currentDateRange.endDate.subtract(const Duration(days: 7)),
    );
  }

  DateRange _calculateDateRangeOfNextMonth() {
    final int currentMonth = (state.dateRange!).startDate.month;
    final int currentYear = (state.dateRange!).startDate.year;
    final DateTime firstDayOfNextMonth =
        DateTime(currentYear, currentMonth + 1);
    return DateRange(
      startDate: firstDayOfNextMonth,
      endDate: _dateService.getLastDayOfTheMonth(
        firstDayOfNextMonth.month,
        firstDayOfNextMonth.year,
      ),
    );
  }

  DateRange _calculateDateRangeOfPreviousMonth() {
    final int currentMonth = (state.dateRange!).startDate.month;
    final int currentYear = (state.dateRange!).startDate.year;
    final DateTime firstDayOfPreviousMonth =
        DateTime(currentYear, currentMonth - 1);
    return DateRange(
      startDate: firstDayOfPreviousMonth,
      endDate: _dateService.getLastDayOfTheMonth(
        firstDayOfPreviousMonth.month,
        firstDayOfPreviousMonth.year,
      ),
    );
  }

  DateRange _calculateDateRangeOfNextYear() {
    final int nextYear = (state.dateRange!).startDate.year + 1;
    return DateRange(
      startDate: _dateService.getFirstDayOfTheYear(nextYear),
      endDate: _dateService.getLastDayOfTheYear(nextYear),
    );
  }

  DateRange _calculateDateRangeOfPreviousYear() {
    final int previousYear = (state.dateRange!).startDate.year - 1;
    return DateRange(
      startDate: _dateService.getFirstDayOfTheYear(previousYear),
      endDate: _dateService.getLastDayOfTheYear(previousYear),
    );
  }
}

class ChartDateRangeState extends Equatable {
  final DateRangeType dateRangeType;
  final DateRange? dateRange;

  const ChartDateRangeState({required this.dateRangeType, this.dateRange});

  @override
  List<Object?> get props => [dateRangeType, dateRange];

  ChartDateRangeState copyWith({
    DateRangeType? dateRangeType,
    DateRange? dateRange,
  }) =>
      ChartDateRangeState(
        dateRangeType: dateRangeType ?? this.dateRangeType,
        dateRange: dateRange ?? this.dateRange,
      );
}

enum DateRangeType { week, month, year }

class DateRange extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const DateRange({required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}
