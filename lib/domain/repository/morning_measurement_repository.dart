import '../model/morning_measurement.dart';

abstract class MorningMeasurementRepository {
  Stream<MorningMeasurement?> getMeasurementByDate({
    required DateTime date,
    required String userId,
  });

  Stream<List<MorningMeasurement>?> getMeasurementsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  });

  Future<void> addMeasurement({
    required String userId,
    required MorningMeasurement measurement,
  });
}
