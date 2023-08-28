part of 'calendar_component_bloc.dart';

abstract class CalendarComponentEvent {
  const CalendarComponentEvent();
}

class CalendarComponentEventInitialize extends CalendarComponentEvent {
  final DateRangeType dateRangeType;

  const CalendarComponentEventInitialize({required this.dateRangeType});
}

class CalendarComponentEventChangeDateRangeType extends CalendarComponentEvent {
  final DateRangeType dateRangeType;

  const CalendarComponentEventChangeDateRangeType({
    required this.dateRangeType,
  });
}

class CalendarComponentEventUserDataUpdated extends CalendarComponentEvent {
  final CalendarUserData userData;

  const CalendarComponentEventUserDataUpdated({required this.userData});
}

class CalendarComponentEventPreviousDateRange extends CalendarComponentEvent {
  const CalendarComponentEventPreviousDateRange();
}

class CalendarComponentEventNextDateRange extends CalendarComponentEvent {
  const CalendarComponentEventNextDateRange();
}

class CalendarComponentEventDayPressed extends CalendarComponentEvent {
  final DateTime date;

  const CalendarComponentEventDayPressed({required this.date});
}

class CalendarComponentEventResetPressedDay extends CalendarComponentEvent {
  const CalendarComponentEventResetPressedDay();
}
