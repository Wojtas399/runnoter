import '../model/morning_measurement.dart';

abstract class MorningMeasurementRepository {
  Future<void> addMeasurement({
    required MorningMeasurement measurement,
  });
}
