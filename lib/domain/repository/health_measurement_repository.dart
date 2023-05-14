import '../model/health_measurement.dart';

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

  Future<void> addMeasurement({
    required HealthMeasurement measurement,
  });
}
