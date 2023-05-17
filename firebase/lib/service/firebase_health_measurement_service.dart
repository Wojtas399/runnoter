import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_collections.dart';
import '../mapper/date_mapper.dart';
import '../model/health_measurement_dto.dart';

class FirebaseHealthMeasurementService {
  Future<HealthMeasurementDto?> loadMeasurementByDate({
    required String userId,
    required DateTime date,
  }) async {
    final measurementId = mapDateTimeToString(date);
    final snapshot =
        await getHealthMeasurementsRef(userId).doc(measurementId).get();
    return snapshot.data();
  }

  Future<List<HealthMeasurementDto>?> loadMeasurementsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) async {
    final snapshot = await getHealthMeasurementsRef(userId)
        .where(
          FieldPath.documentId,
          isGreaterThanOrEqualTo: mapDateTimeToString(startDate),
        )
        .where(
          FieldPath.documentId,
          isLessThanOrEqualTo: mapDateTimeToString(endDate),
        )
        .get();
    return snapshot.docs
        .map(
          (QueryDocumentSnapshot<HealthMeasurementDto> docSnapshot) =>
              docSnapshot.data(),
        )
        .toList();
  }

  Future<List<HealthMeasurementDto>?> loadAllMeasurements({
    required String userId,
  }) async {
    final snapshot = await getHealthMeasurementsRef(userId).get();
    return snapshot.docs
        .map(
          (QueryDocumentSnapshot<HealthMeasurementDto> docSnapshot) =>
              docSnapshot.data(),
        )
        .toList();
  }

  Future<HealthMeasurementDto?> addMeasurement({
    required String userId,
    required HealthMeasurementDto measurementDto,
  }) async {
    final String measurementId = mapDateTimeToString(measurementDto.date);
    final measurementRef = getHealthMeasurementsRef(userId).doc(measurementId);
    await measurementRef.set(measurementDto);
    final snapshot = await measurementRef.get();
    return snapshot.data();
  }

  Future<HealthMeasurementDto?> updateMeasurement({
    required String userId,
    required DateTime date,
    int? restingHeartRate,
    double? fastingWeight,
  }) async {
    final String measurementId = mapDateTimeToString(date);
    final measurementRef = getHealthMeasurementsRef(userId).doc(measurementId);
    final Map<String, dynamic> jsonToUpdate =
        createHealthMeasurementJsonToUpdate(
      restingHeartRate: restingHeartRate,
      fastingWeight: fastingWeight,
    );
    await measurementRef.update(jsonToUpdate);
    final snapshot = await measurementRef.get();
    return snapshot.data();
  }

  Future<void> deleteMeasurement({
    required String userId,
    required DateTime date,
  }) async {
    final String measurementId = mapDateTimeToString(date);
    await getHealthMeasurementsRef(userId).doc(measurementId).delete();
  }
}
