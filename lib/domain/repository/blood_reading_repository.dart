import '../model/blood_reading.dart';

abstract interface class BloodReadingRepository {
  Stream<List<BloodReading>?> getAllReadings({
    required String userId,
  });

  Future<void> addNewReading({
    required String userId,
    required DateTime date,
    required List<BloodReadingParameter> parameters,
  });
}
