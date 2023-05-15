abstract class HealthMeasurementCreatorEvent {
  const HealthMeasurementCreatorEvent();
}

class HealthMeasurementCreatorEventInitialize
    extends HealthMeasurementCreatorEvent {
  final DateTime? date;

  const HealthMeasurementCreatorEventInitialize({
    required this.date,
  });
}

class HealthMeasurementCreatorEventRestingHeartRateChanged
    extends HealthMeasurementCreatorEvent {
  final int? restingHeartRate;

  const HealthMeasurementCreatorEventRestingHeartRateChanged({
    required this.restingHeartRate,
  });
}

class HealthMeasurementCreatorEventFastingWeightChanged
    extends HealthMeasurementCreatorEvent {
  final double? fastingWeight;

  const HealthMeasurementCreatorEventFastingWeightChanged({
    required this.fastingWeight,
  });
}

class HealthMeasurementCreatorEventSubmit
    extends HealthMeasurementCreatorEvent {
  const HealthMeasurementCreatorEventSubmit();
}
