import '../model/morning_measurement.dart';

abstract class MorningMeasurementRepository {
  Future<void> addMeasurement({
    required String userId,
    required MorningMeasurement measurement,
  });
}
