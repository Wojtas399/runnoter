import '../model/blood_readings.dart';

abstract interface class BloodReadingsRepository {
  Stream<List<BloodReadings>?> getAllReadings({
    required String userId,
  });

  Future<void> addNewReadings({
    required String userId,
    required DateTime date,
    required List<BloodParameterReading> readings,
  });
}
