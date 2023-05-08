part of 'calendar_bloc.dart';

abstract class CalendarEvent {
  const CalendarEvent();
}

class CalendarEventWorkoutsUpdated extends CalendarEvent {
  final List<Workout>? workouts;

  const CalendarEventWorkoutsUpdated({
    required this.workouts,
  });
}

class CalendarEventMonthChanged extends CalendarEvent {
  final DateTime firstDisplayingDate;
  final DateTime lastDisplayingDate;

  const CalendarEventMonthChanged({
    required this.firstDisplayingDate,
    required this.lastDisplayingDate,
  });
}
