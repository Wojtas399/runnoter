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

class CalendarComponentEventActivitiesUpdated extends CalendarComponentEvent {
  final List<CalendarDayActivity> activities;

  const CalendarComponentEventActivitiesUpdated({required this.activities});
}

class CalendarComponentEventPreviousDateRange extends CalendarComponentEvent {
  const CalendarComponentEventPreviousDateRange();
}

class CalendarComponentEventNextDateRange extends CalendarComponentEvent {
  const CalendarComponentEventNextDateRange();
}

class CalendarComponentEventOnDayPressed extends CalendarComponentEvent {
  final DateTime date;

  const CalendarComponentEventOnDayPressed({required this.date});
}
