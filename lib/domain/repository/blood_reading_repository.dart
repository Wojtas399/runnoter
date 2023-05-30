import '../model/blood_reading.dart';

abstract interface class BloodReadingRepository {
  Stream<BloodReading?> getReadingById({
    required String bloodReadingId,
    required String userId,
  });

  Stream<List<BloodReading>?> getAllReadings({
    required String userId,
  });

  Future<void> addNewReading({
    required String userId,
    required DateTime date,
    required List<BloodReadingParameter> parameters,
  });
}
