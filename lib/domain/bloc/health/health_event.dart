part of 'health_bloc.dart';

abstract class HealthEvent {
  const HealthEvent();
}

class HealthEventInitialize extends HealthEvent {
  const HealthEventInitialize();
}

class HealthEventMeasurementsFromDateRangeUpdated extends HealthEvent {
  final List<HealthMeasurement>? measurements;

  const HealthEventMeasurementsFromDateRangeUpdated({
    required this.measurements,
  });
}

class HealthEventAddTodayMeasurement extends HealthEvent {
  final int restingHeartRate;
  final double fastingWeight;

  const HealthEventAddTodayMeasurement({
    required this.restingHeartRate,
    required this.fastingWeight,
  });
}

class HealthEventDeleteTodayMeasurement extends HealthEvent {
  const HealthEventDeleteTodayMeasurement();
}

class HealthEventChangeChartRangeType extends HealthEvent {
  final ChartRange chartRangeType;

  const HealthEventChangeChartRangeType({
    required this.chartRangeType,
  });
}

class HealthEventPreviousChartRange extends HealthEvent {
  const HealthEventPreviousChartRange();
}

class HealthEventNextChartRange extends HealthEvent {
  const HealthEventNextChartRange();
}
