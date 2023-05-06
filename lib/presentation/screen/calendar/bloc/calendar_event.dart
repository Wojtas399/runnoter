abstract class CalendarEvent {
  const CalendarEvent();
}

class CalendarEventInitialize extends CalendarEvent {
  const CalendarEventInitialize();
}

class CalendarEventMonthChanged extends CalendarEvent {
  final int month;
  final int year;

  const CalendarEventMonthChanged({
    required this.month,
    required this.year,
  });
}
