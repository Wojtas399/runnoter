import '../entity/health_measurement.dart';

abstract class HealthMeasurementRepository {
  Stream<HealthMeasurement?> getMeasurementByDate({
    required DateTime date,
    required String userId,
  });

  Stream<List<HealthMeasurement>?> getMeasurementsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  });

  Stream<List<HealthMeasurement>?> getAllMeasurements({
    required String userId,
  });

  Future<void> addMeasurement({
    required HealthMeasurement measurement,
  });

  Future<void> updateMeasurement({
    required String userId,
    required DateTime date,
    int? restingHeartRate,
    double? fastingWeight,
  });

  Future<void> deleteMeasurement({
    required String userId,
    required DateTime date,
  });

  Future<void> deleteAllUserMeasurements({
    required String userId,
  });
}
