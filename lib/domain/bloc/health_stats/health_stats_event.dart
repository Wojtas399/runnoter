part of 'health_stats_bloc.dart';

abstract class HealthStatsEvent {
  const HealthStatsEvent();
}

class HealthStatsEventInitialize extends HealthStatsEvent {
  const HealthStatsEventInitialize();
}

class HealthStatsEventChartDateRangeUpdated extends HealthStatsEvent {
  final ChartDateRangeState chartDateRange;

  const HealthStatsEventChartDateRangeUpdated({required this.chartDateRange});
}

class HealthStatsEventChangeChartDateRangeType extends HealthStatsEvent {
  final DateRangeType dateRangeType;

  const HealthStatsEventChangeChartDateRangeType({required this.dateRangeType});
}

class HealthStatsEventPreviousChartDateRange extends HealthStatsEvent {
  const HealthStatsEventPreviousChartDateRange();
}

class HealthStatsEventNextChartDateRange extends HealthStatsEvent {
  const HealthStatsEventNextChartDateRange();
}
