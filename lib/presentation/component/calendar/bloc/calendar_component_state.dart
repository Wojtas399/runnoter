part of 'calendar_component_bloc.dart';

class CalendarComponentState extends Equatable {
  final DateRange? dateRange;
  final List<CalendarWeek>? weeks;
  final DateTime? pressedDay;

  const CalendarComponentState({this.dateRange, this.weeks, this.pressedDay});

  @override
  List<Object?> get props => [dateRange, weeks, pressedDay];

  CalendarComponentState copyWith({
    DateRange? dateRange,
    List<CalendarWeek>? weeks,
    DateTime? pressedDay,
  }) =>
      CalendarComponentState(
        dateRange: dateRange ?? this.dateRange,
        weeks: weeks ?? this.weeks,
        pressedDay: pressedDay,
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
  final List<CalendarWeekDay> days;

  const CalendarWeek({required this.days});

  @override
  List<Object?> get props => [days];
}
