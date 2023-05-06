part of 'calendar_bloc.dart';

abstract class CalendarEvent {
  const CalendarEvent();
}

class CalendarEventInitialize extends CalendarEvent {
  const CalendarEventInitialize();
}

class CalendarEventWorkoutsUpdated extends CalendarEvent {
  final List<Workout>? workouts;

  const CalendarEventWorkoutsUpdated({
    required this.workouts,
  });
}

class CalendarEventMonthChanged extends CalendarEvent {
  final int month;
  final int year;

  const CalendarEventMonthChanged({
    required this.month,
    required this.year,
  });
}
