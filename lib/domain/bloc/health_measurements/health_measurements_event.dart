part of 'health_measurements_bloc.dart';

abstract class HealthMeasurementsEvent {
  const HealthMeasurementsEvent();
}

class HealthMeasurementsEventInitialize extends HealthMeasurementsEvent {
  const HealthMeasurementsEventInitialize();
}

class HealthMeasurementsEventMeasurementsUpdated
    extends HealthMeasurementsEvent {
  final List<HealthMeasurement>? measurements;

  const HealthMeasurementsEventMeasurementsUpdated({
    required this.measurements,
  });
}

class HealthMeasurementsEventDeleteMeasurement extends HealthMeasurementsEvent {
  final DateTime date;

  const HealthMeasurementsEventDeleteMeasurement({
    required this.date,
  });
}
