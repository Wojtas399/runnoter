part of 'calendar_cubit.dart';

class CalendarState extends Equatable {
  final DateRangeType dateRangeType;
  final DateRange? dateRange;
  final List<Week>? weeks;
  final DateTime? pressedDay;

  const CalendarState({
    required this.dateRangeType,
    this.dateRange,
    this.weeks,
    this.pressedDay,
  });

  @override
  List<Object?> get props => [
        dateRangeType,
        dateRange,
        weeks,
        pressedDay,
      ];

  CalendarState copyWith({
    DateRangeType? dateRangeType,
    DateRange? dateRange,
    List<Week>? weeks,
    DateTime? pressedDay,
  }) =>
      CalendarState(
        dateRangeType: dateRangeType ?? this.dateRangeType,
        dateRange: dateRange ?? this.dateRange,
        weeks: weeks ?? this.weeks,
        pressedDay: pressedDay,
      );
}

class Week extends Equatable {
  final List<WeekDay> days;

  const Week({required this.days});

  @override
  List<Object?> get props => [days];
}
