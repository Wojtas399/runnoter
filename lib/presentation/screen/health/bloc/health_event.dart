part of 'health_bloc.dart';

abstract class HealthEvent {
  const HealthEvent();
}

class HealthEventInitialize extends HealthEvent {
  const HealthEventInitialize();
}

class HealthEventMorningMeasurementUpdated extends HealthEvent {
  final MorningMeasurement updatedMorningMeasurement;

  const HealthEventMorningMeasurementUpdated({
    required this.updatedMorningMeasurement,
  });
}

class HealthEventAddMorningMeasurement extends HealthEvent {
  final int restingHeartRate;
  final double weight;

  const HealthEventAddMorningMeasurement({
    required this.restingHeartRate,
    required this.weight,
  });
}

class HealthEventChangeChartRange extends HealthEvent {
  final ChartRange newChartRange;

  const HealthEventChangeChartRange({
    required this.newChartRange,
  });
}

class HealthEventPreviousChartRange extends HealthEvent {
  const HealthEventPreviousChartRange();
}

class HealthEventNextChartRange extends HealthEvent {
  const HealthEventNextChartRange();
}
