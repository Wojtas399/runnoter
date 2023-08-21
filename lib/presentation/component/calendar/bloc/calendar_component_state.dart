part of 'calendar_component_bloc.dart';

class CalendarComponentState extends Equatable {
  final DateRange? dateRange;
  final List<CalendarWeek>? weeks;

  const CalendarComponentState({
    this.dateRange,
    this.weeks,
  });

  @override
  List<Object?> get props => [dateRange, weeks];

  CalendarComponentState copyWith({
    DateRange? dateRange,
    List<CalendarWeek>? weeks,
  }) =>
      CalendarComponentState(
        dateRange: dateRange ?? this.dateRange,
        weeks: weeks ?? this.weeks,
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
  final HealthMeasurement? healthMeasurement;
  final List<Workout> workouts;
  final List<Race> races;

  const CalendarDay({
    required this.date,
    required this.isDisabled,
    required this.isTodayDay,
    this.healthMeasurement,
    this.workouts = const [],
    this.races = const [],
  });

  @override
  List<Object?> get props => [
        date,
        isDisabled,
        isTodayDay,
        healthMeasurement,
        workouts,
        races,
      ];
}
