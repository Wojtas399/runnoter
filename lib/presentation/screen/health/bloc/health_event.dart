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
  final List<MorningMeasurement>? morningMeasurementsFromDateRange;

  const HealthEventMorningMeasurementsFromDateRangeUpdated({
    required this.morningMeasurementsFromDateRange,
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
