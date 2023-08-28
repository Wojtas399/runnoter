part of 'calendar_component_bloc.dart';

class CalendarComponentState extends Equatable {
  final DateRangeType dateRangeType;
  final DateRange? dateRange;
  final List<CalendarWeek>? weeks;
  final DateTime? pressedDay;

  const CalendarComponentState({
    required this.dateRangeType,
    this.dateRange,
    this.weeks,
    this.pressedDay,
  });

  @override
  List<Object?> get props => [dateRange, weeks, pressedDay];

  CalendarComponentState copyWith({
    DateRangeType? dateRangeType,
    DateRange? dateRange,
    List<CalendarWeek>? weeks,
    DateTime? pressedDay,
  }) =>
      CalendarComponentState(
        dateRangeType: dateRangeType ?? this.dateRangeType,
        dateRange: dateRange ?? this.dateRange,
        weeks: weeks ?? this.weeks,
        pressedDay: pressedDay,
      );
}

class CalendarWeek extends Equatable {
  final List<CalendarWeekDay> days;

  const CalendarWeek({required this.days});

  @override
  List<Object?> get props => [days];
}
