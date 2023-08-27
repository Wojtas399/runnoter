part of 'health_bloc.dart';

abstract class HealthEvent {
  const HealthEvent();
}

class HealthEventInitializeChartDateRangeListener extends HealthEvent {
  const HealthEventInitializeChartDateRangeListener();
}

class HealthEventChartDateRangeUpdated extends HealthEvent {
  final ChartDateRangeState chartDateRange;

  const HealthEventChartDateRangeUpdated({required this.chartDateRange});
}

class HealthEventChangeChartDateRangeType extends HealthEvent {
  final DateRangeType dateRangeType;

  const HealthEventChangeChartDateRangeType({required this.dateRangeType});
}

class HealthEventPreviousChartDateRange extends HealthEvent {
  const HealthEventPreviousChartDateRange();
}

class HealthEventNextChartDateRange extends HealthEvent {
  const HealthEventNextChartDateRange();
}
