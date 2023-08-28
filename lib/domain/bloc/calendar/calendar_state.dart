part of 'calendar_bloc.dart';

class CalendarState extends Equatable {
  final DateRangeType dateRangeType;
  final DateRange? dateRange;
  final bool areUserDataLoaded;
  final List<CalendarWeek>? weeks;
  final DateTime? pressedDay;

  const CalendarState({
    required this.dateRangeType,
    this.dateRange,
    this.areUserDataLoaded = false,
    this.weeks,
    this.pressedDay,
  });

  @override
  List<Object?> get props => [
        dateRangeType,
        dateRange,
        areUserDataLoaded,
        weeks,
        pressedDay,
      ];

  CalendarState copyWith({
    DateRangeType? dateRangeType,
    DateRange? dateRange,
    bool? areUserDataLoaded,
    List<CalendarWeek>? weeks,
    DateTime? pressedDay,
  }) =>
      CalendarState(
        dateRangeType: dateRangeType ?? this.dateRangeType,
        dateRange: dateRange ?? this.dateRange,
        areUserDataLoaded: areUserDataLoaded ?? this.areUserDataLoaded,
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
