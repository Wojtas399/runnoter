part of 'mileage_stats_bloc.dart';

abstract class MileageStatsEvent {
  const MileageStatsEvent();
}

class MileageStatsEventInitialize extends MileageStatsEvent {
  const MileageStatsEventInitialize();
}

class MileageStatsEventChartDateRangeUpdated extends MileageStatsEvent {
  final ChartDateRangeState chartDateRange;

  const MileageStatsEventChartDateRangeUpdated({required this.chartDateRange});
}

class MileageStatsEventChangeDateRangeType extends MileageStatsEvent {
  final DateRangeType dateRangeType;

  const MileageStatsEventChangeDateRangeType({required this.dateRangeType});
}

class MileageStatsEventPreviousDateRange extends MileageStatsEvent {
  const MileageStatsEventPreviousDateRange();
}

class MileageStatsEventNextDateRange extends MileageStatsEvent {
  const MileageStatsEventNextDateRange();
}
