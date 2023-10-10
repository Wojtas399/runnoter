import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_collections.dart';
import '../mapper/date_mapper.dart';
import '../model/health_measurement_dto.dart';
import '../utils/utils.dart';

class FirebaseHealthMeasurementService {
  Future<HealthMeasurementDto?> loadMeasurementByDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final measurementId = mapDateTimeToString(date);
      final snapshot =
          await getHealthMeasurementsRef(userId).doc(measurementId).get();
      return snapshot.data();
    } catch (exception) {
      if (exception.toString().contains('unavailable')) {
        return null;
      } else {
        rethrow;
      }
    }
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
    await asyncOrSyncCall(
      () => measurementRef.set(measurementDto),
    );
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
    await asyncOrSyncCall(
      () => measurementRef.update(jsonToUpdate),
    );
    final snapshot = await measurementRef.get();
    return snapshot.data();
  }

  Future<void> deleteMeasurement({
    required String userId,
    required DateTime date,
  }) async {
    final String measurementId = mapDateTimeToString(date);
    await asyncOrSyncCall(
      () => getHealthMeasurementsRef(userId).doc(measurementId).delete(),
    );
  }

  Future<List<String>> deleteAllUserMeasurements({
    required String userId,
  }) async {
    final measurementsRef = getHealthMeasurementsRef(userId);
    final snapshot = await measurementsRef.get();
    final List<String> idsOfDeletedMeasurements = [];
    final WriteBatch batch = FirebaseFirestore.instance.batch();
    for (final docSnapshot in snapshot.docs) {
      batch.delete(docSnapshot.reference);
      idsOfDeletedMeasurements.add(docSnapshot.id);
    }
    await asyncOrSyncCall(
      () => batch.commit(),
    );
    return idsOfDeletedMeasurements;
  }
}
