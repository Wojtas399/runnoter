part of 'calendar_component_bloc.dart';

class CalendarComponentState extends Equatable {
  final CalendarDateRange? dateRange;
  final List<CalendarWeek>? weeks;
  final DateTime? pressedDay;

  const CalendarComponentState({this.dateRange, this.weeks, this.pressedDay});

  @override
  List<Object?> get props => [dateRange, weeks, pressedDay];

  CalendarComponentState copyWith({
    CalendarDateRange? dateRange,
    List<CalendarWeek>? weeks,
    DateTime? pressedDay,
  }) =>
      CalendarComponentState(
        dateRange: dateRange ?? this.dateRange,
        weeks: weeks ?? this.weeks,
        pressedDay: pressedDay,
      );
}

sealed class CalendarDateRange extends Equatable {
  const CalendarDateRange();
}

class CalendarDateRangeWeek extends CalendarDateRange {
  final DateTime firstDayOfTheWeek;

  const CalendarDateRangeWeek({required this.firstDayOfTheWeek});

  @override
  List<Object?> get props => [firstDayOfTheWeek];
}

class CalendarDateRangeMonth extends CalendarDateRange {
  final int month;
  final int year;

  const CalendarDateRangeMonth({required this.month, required this.year});

  @override
  List<Object?> get props => [month, year];
}

class CalendarWeek extends Equatable {
  final List<CalendarWeekDay> days;

  const CalendarWeek({required this.days});

  @override
  List<Object?> get props => [days];
}
