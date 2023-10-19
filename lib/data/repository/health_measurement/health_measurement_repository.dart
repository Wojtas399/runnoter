import '../../model/health_measurement.dart';

abstract interface class HealthMeasurementRepository {
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

  Future<void> refreshMeasurementsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  });

  Future<bool> doesMeasurementFromDateExist({
    required String userId,
    required DateTime date,
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
