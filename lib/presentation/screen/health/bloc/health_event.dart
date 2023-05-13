part of 'health_bloc.dart';

abstract class HealthEvent {
  const HealthEvent();
}

class HealthEventInitialize extends HealthEvent {
  const HealthEventInitialize();
}

class HealthEventThisMorningMeasurementUpdated extends HealthEvent {
  final MorningMeasurement? thisMorningMeasurement;

  const HealthEventThisMorningMeasurementUpdated({
    required this.thisMorningMeasurement,
  });
}

class HealthEventMorningMeasurementsFromDateRangeUpdated extends HealthEvent {
  final List<MorningMeasurement>? measurements;

  const HealthEventMorningMeasurementsFromDateRangeUpdated({
    required this.measurements,
  });
}

class HealthEventAddMorningMeasurement extends HealthEvent {
  final int restingHeartRate;
  final double fastingWeight;

  const HealthEventAddMorningMeasurement({
    required this.restingHeartRate,
    required this.fastingWeight,
  });
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
