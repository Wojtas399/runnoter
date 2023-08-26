part of 'mileage_bloc.dart';

abstract class MileageEvent {
  const MileageEvent();
}

class MileageEventInitialize extends MileageEvent {
  const MileageEventInitialize();
}

class MileageEventChartDateRangeUpdated extends MileageEvent {
  final ChartDateRangeState chartDateRange;

  const MileageEventChartDateRangeUpdated({required this.chartDateRange});
}

class MileageEventChangeDateRangeType extends MileageEvent {
  final DateRangeType dateRangeType;

  const MileageEventChangeDateRangeType({required this.dateRangeType});
}

class MileageEventPreviousDateRange extends MileageEvent {
  const MileageEventPreviousDateRange();
}

class MileageEventNextDateRange extends MileageEvent {
  const MileageEventNextDateRange();
}
