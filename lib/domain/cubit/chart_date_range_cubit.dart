import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/date_service.dart';
import '../../dependency_injection.dart';

class ChartDateRangeCubit extends Cubit<ChartDateRange?> {
  final DateService _dateService;

  ChartDateRangeCubit({ChartDateRange? initialDateRange})
      : _dateService = getIt<DateService>(),
        super(initialDateRange);

  void setWeekDateRange() {
    final DateTime today = _dateService.getToday();
    final ChartDateRangeWeek weekDateRange = ChartDateRangeWeek(
      firstDateOfTheWeek: _dateService.getFirstDayOfTheWeek(today),
      lastDateOfTheWeek: _dateService.getLastDayOfTheWeek(today),
    );
    emit(weekDateRange);
  }

  void setMonthDateRange() {
    final DateTime today = _dateService.getToday();
    final ChartDateRangeMonth monthDateRange = ChartDateRangeMonth(
      month: today.month,
      year: today.year,
    );
    emit(monthDateRange);
  }

  void setYearDateRange() {
    final DateTime today = _dateService.getToday();
    final ChartDateRangeYear yearDateRange = ChartDateRangeYear(
      year: today.year,
    );
    emit(yearDateRange);
  }

  void nextDateRange() {
    final ChartDateRange? currentDateRange = state;
    if (currentDateRange == null) return;
    final ChartDateRange newDateRange = switch (currentDateRange) {
      ChartDateRangeWeek() => _calculateNextWeek(),
      ChartDateRangeMonth() => _calculateNextMonth(),
      ChartDateRangeYear() => ChartDateRangeYear(
          year: currentDateRange.year + 1,
        ),
    };
    emit(newDateRange);
  }

  void previousDateRange() {
    final ChartDateRange? currentDateRange = state;
    if (currentDateRange == null) return;
    final ChartDateRange newDateRange = switch (currentDateRange) {
      ChartDateRangeWeek() => _calculatePreviousWeek(),
      ChartDateRangeMonth() => _calculatePreviousMonth(),
      ChartDateRangeYear() => ChartDateRangeYear(
          year: currentDateRange.year - 1,
        ),
    };
    emit(newDateRange);
  }

  ChartDateRangeWeek _calculateNextWeek() {
    final ChartDateRangeWeek currentWeek = state as ChartDateRangeWeek;
    return ChartDateRangeWeek(
      firstDateOfTheWeek: currentWeek.firstDateOfTheWeek.add(
        const Duration(days: 7),
      ),
      lastDateOfTheWeek: currentWeek.lastDateOfTheWeek.add(
        const Duration(days: 7),
      ),
    );
  }

  ChartDateRangeWeek _calculatePreviousWeek() {
    final ChartDateRangeWeek currentWeek = state as ChartDateRangeWeek;
    return ChartDateRangeWeek(
      firstDateOfTheWeek: currentWeek.firstDateOfTheWeek.subtract(
        const Duration(days: 7),
      ),
      lastDateOfTheWeek: currentWeek.lastDateOfTheWeek.subtract(
        const Duration(days: 7),
      ),
    );
  }

  ChartDateRangeMonth _calculateNextMonth() {
    final ChartDateRangeMonth currentMonth = state as ChartDateRangeMonth;
    final DateTime nextMonthDate =
        DateTime(currentMonth.year, currentMonth.month + 1);
    return ChartDateRangeMonth(
      month: nextMonthDate.month,
      year: nextMonthDate.year,
    );
  }

  ChartDateRangeMonth _calculatePreviousMonth() {
    final ChartDateRangeMonth currentMonth = state as ChartDateRangeMonth;
    final DateTime previousMonthDate =
        DateTime(currentMonth.year, currentMonth.month - 1);
    return ChartDateRangeMonth(
      month: previousMonthDate.month,
      year: previousMonthDate.year,
    );
  }
}

sealed class ChartDateRange extends Equatable {
  const ChartDateRange();
}

class ChartDateRangeWeek extends ChartDateRange {
  final DateTime firstDateOfTheWeek;
  final DateTime lastDateOfTheWeek;

  const ChartDateRangeWeek({
    required this.firstDateOfTheWeek,
    required this.lastDateOfTheWeek,
  });

  @override
  List<Object?> get props => [firstDateOfTheWeek, lastDateOfTheWeek];
}

class ChartDateRangeMonth extends ChartDateRange {
  final int month;
  final int year;

  const ChartDateRangeMonth({required this.month, required this.year});

  @override
  List<Object?> get props => [month, year];
}

class ChartDateRangeYear extends ChartDateRange {
  final int year;

  const ChartDateRangeYear({required this.year});

  @override
  List<Object?> get props => [year];
}
