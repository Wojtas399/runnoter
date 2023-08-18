part of 'calendar_component_bloc.dart';

class CalendarComponentState extends Equatable {
  final DateRange? dateRange;
  final List<CalendarWeek>? weeks;
  final DateTime? pressedDate;

  const CalendarComponentState({
    this.dateRange,
    this.weeks,
    this.pressedDate,
  });

  @override
  List<Object?> get props => [dateRange, weeks, pressedDate];

  CalendarComponentState copyWith({
    DateRange? dateRange,
    List<CalendarWeek>? weeks,
    DateTime? pressedDate,
  }) =>
      CalendarComponentState(
        dateRange: dateRange ?? this.dateRange,
        weeks: weeks ?? this.weeks,
        pressedDate: pressedDate,
      );
}

sealed class DateRange extends Equatable {
  const DateRange();
}

class DateRangeWeek extends DateRange {
  final DateTime firstDayOfTheWeek;

  const DateRangeWeek({required this.firstDayOfTheWeek});

  @override
  List<Object?> get props => [firstDayOfTheWeek];
}

class DateRangeMonth extends DateRange {
  final int month;
  final int year;

  const DateRangeMonth({required this.month, required this.year});

  @override
  List<Object?> get props => [month, year];
}

class CalendarWeek extends Equatable {
  final List<CalendarDay> days;

  const CalendarWeek({required this.days});

  @override
  List<Object?> get props => [days];
}

class CalendarDay extends Equatable {
  final DateTime date;
  final bool isDisabled;
  final bool isTodayDay;
  final List<CalendarDayActivity> activities;

  const CalendarDay({
    required this.date,
    required this.isDisabled,
    required this.isTodayDay,
    this.activities = const [],
  });

  @override
  List<Object?> get props => [date, isDisabled, isTodayDay, activities];
}

class CalendarDayActivity extends Equatable {
  final DateTime date;
  final Color color;

  const CalendarDayActivity({required this.date, required this.color});

  @override
  List<Object?> get props => [date, color];
}
