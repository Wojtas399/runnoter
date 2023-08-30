part of 'calendar_bloc.dart';

abstract class CalendarEvent {
  const CalendarEvent();
}

class CalendarEventInitialize extends CalendarEvent {
  final DateRangeType dateRangeType;

  const CalendarEventInitialize({required this.dateRangeType});
}

class CalendarEventChangeDateRangeType extends CalendarEvent {
  final DateRangeType dateRangeType;

  const CalendarEventChangeDateRangeType({
    required this.dateRangeType,
  });
}

class CalendarEventUserDataUpdated extends CalendarEvent {
  final CalendarUserData userData;

  const CalendarEventUserDataUpdated({required this.userData});
}

class CalendarEventPreviousDateRange extends CalendarEvent {
  const CalendarEventPreviousDateRange();
}

class CalendarEventNextDateRange extends CalendarEvent {
  const CalendarEventNextDateRange();
}

class CalendarEventDayPressed extends CalendarEvent {
  final DateTime date;

  const CalendarEventDayPressed({required this.date});
}

class CalendarEventResetPressedDay extends CalendarEvent {
  const CalendarEventResetPressedDay();
}
