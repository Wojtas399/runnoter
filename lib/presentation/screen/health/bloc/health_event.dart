import '../../../../domain/model/morning_measurement.dart';
import 'health_state.dart';

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
  const HealthEventAddMorningMeasurement();
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
