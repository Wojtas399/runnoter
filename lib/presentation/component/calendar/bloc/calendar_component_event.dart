part of 'calendar_component_bloc.dart';

abstract class CalendarComponentEvent {
  const CalendarComponentEvent();
}

class CalendarComponentEventInitialize extends CalendarComponentEvent {
  final DateRangeType dateRangeType;

  const CalendarComponentEventInitialize({required this.dateRangeType});
}

class CalendarComponentEventChangeDateRange extends CalendarComponentEvent {
  final DateRangeType dateRangeType;

  const CalendarComponentEventChangeDateRange({required this.dateRangeType});
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
