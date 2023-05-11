part of 'health_bloc.dart';

abstract class HealthEvent {
  const HealthEvent();
}

class HealthEventInitialize extends HealthEvent {
  const HealthEventInitialize();
}

class HealthEventListenedParamsUpdated extends HealthEvent {
  final HealthStateListenedParams updatedListenedParams;

  const HealthEventListenedParamsUpdated({
    required this.updatedListenedParams,
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
