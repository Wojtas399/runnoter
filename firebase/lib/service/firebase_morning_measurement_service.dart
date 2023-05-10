import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_collections.dart';
import '../mapper/date_mapper.dart';
import '../model/morning_measurement_dto.dart';

class FirebaseMorningMeasurementService {
  Future<MorningMeasurementDto?> loadMeasurementByDate({
    required String userId,
    required DateTime date,
  }) async {
    final measurementId = mapDateTimeToString(date);
    final snapshot =
        await getMorningMeasurementsRef(userId).doc(measurementId).get();
    return snapshot.data();
  }

  Future<List<MorningMeasurementDto>?> loadMeasurementsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) async {
    final snapshot = await getMorningMeasurementsRef(userId)
        .where(
          'id',
          isGreaterThanOrEqualTo: mapDateTimeToString(startDate),
        )
        .where(
          'id',
          isLessThanOrEqualTo: mapDateTimeToString(endDate),
        )
        .get();
    return snapshot.docs
        .map(
          (QueryDocumentSnapshot<MorningMeasurementDto> docSnapshot) =>
              docSnapshot.data(),
        )
        .toList();
  }

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
