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

class CalendarComponentEventDateRangeDataUpdated
    extends CalendarComponentEvent {
  final CalendarDateRangeData data;

  const CalendarComponentEventDateRangeDataUpdated({required this.data});
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
