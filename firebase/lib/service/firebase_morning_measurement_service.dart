import '../firebase_collections.dart';
import '../mapper/date_mapper.dart';
import '../model/morning_measurement_dto.dart';

class FirebaseMorningMeasurementService {
  Future<MorningMeasurementDto?> addMeasurement({
    required String userId,
    required MorningMeasurementDto measurementDto,
  }) async {
    final String measurementId = mapDateTimeToString(measurementDto.date);
    final measurementRef = getMorningMeasurementsRef(userId).doc(measurementId);
    await measurementRef.set(measurementDto);
    final snapshot = await measurementRef.get();
    return snapshot.data();
  }
}
