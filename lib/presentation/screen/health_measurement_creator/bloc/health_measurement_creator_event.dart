part of 'health_measurement_creator_bloc.dart';

abstract class HealthMeasurementCreatorEvent {
  const HealthMeasurementCreatorEvent();
}

class HealthMeasurementCreatorEventInitialize
    extends HealthMeasurementCreatorEvent {
  final DateTime? date;

  const HealthMeasurementCreatorEventInitialize({
    this.date,
  });
}

class HealthMeasurementCreatorEventRestingHeartRateChanged
    extends HealthMeasurementCreatorEvent {
  final String? restingHeartRateStr;

  const HealthMeasurementCreatorEventRestingHeartRateChanged({
    required this.restingHeartRateStr,
  });
}

class HealthMeasurementCreatorEventFastingWeightChanged
    extends HealthMeasurementCreatorEvent {
  final String? fastingWeightStr;

  const HealthMeasurementCreatorEventFastingWeightChanged({
    required this.fastingWeightStr,
  });
}

class HealthMeasurementCreatorEventSubmit
    extends HealthMeasurementCreatorEvent {
  const HealthMeasurementCreatorEventSubmit();
}
