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

class CalendarComponentEventActivitiesAndHealthMeasurementsUpdated
    extends CalendarComponentEvent {
  final List<HealthMeasurement> healthMeasurements;
  final List<Workout> workouts;
  final List<Race> races;

  const CalendarComponentEventActivitiesAndHealthMeasurementsUpdated({
    required this.healthMeasurements,
    required this.workouts,
    required this.races,
  });
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
