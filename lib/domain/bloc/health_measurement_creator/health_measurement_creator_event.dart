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

class HealthMeasurementCreatorEventDateChanged
    extends HealthMeasurementCreatorEvent {
  final DateTime date;

  const HealthMeasurementCreatorEventDateChanged({
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
