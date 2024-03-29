import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_collections.dart';
import '../mapper/custom_firebase_exception_mapper.dart';
import '../mapper/date_mapper.dart';
import '../model/activity_status_dto.dart';
import '../model/race_dto.dart';
import '../utils/utils.dart';

class FirebaseRaceService {
  Future<RaceDto?> loadRaceById({
    required String raceId,
    required String userId,
  }) async {
    final snapshot = await getRacesRef(userId).doc(raceId).get();
    return snapshot.data();
  }

  Future<List<RaceDto>?> loadRacesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) async {
    final snapshot = await getRacesRef(userId)
        .where(
          raceDtoDateField,
          isGreaterThanOrEqualTo: mapDateTimeToString(startDate),
        )
        .where(
          raceDtoDateField,
          isLessThanOrEqualTo: mapDateTimeToString(endDate),
        )
        .get();
    return snapshot.docs
        .map(
          (QueryDocumentSnapshot<RaceDto> docSnapshot) => docSnapshot.data(),
        )
        .toList();
  }

  Future<List<RaceDto>?> loadRacesByDate({
    required DateTime date,
    required String userId,
  }) async {
    final snapshot = await getRacesRef(userId)
        .where(
          raceDtoDateField,
          isEqualTo: mapDateTimeToString(date),
        )
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<RaceDto>?> loadRacesByUserId({required String userId}) async {
    final snapshot = await getRacesRef(userId).get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  Future<RaceDto?> addNewRace({
    required String userId,
    required String name,
    required DateTime date,
    required String place,
    required double distance,
    required Duration? expectedDuration,
    required ActivityStatusDto statusDto,
  }) async {
    final competitionRef = getRacesRef(userId).doc();
    final RaceDto competitionDto = RaceDto(
      id: '',
      userId: userId,
      name: name,
      date: date,
      place: place,
      distance: distance,
      expectedDuration: expectedDuration,
      statusDto: statusDto,
    );
    await asyncOrSyncCall(
      () => competitionRef.set(competitionDto),
    );
    final snapshot = await competitionRef.get();
    return snapshot.data();
  }

  Future<RaceDto?> updateRace({
    required String raceId,
    required String userId,
    String? name,
    DateTime? date,
    String? place,
    double? distance,
    Duration? expectedDuration,
    bool setDurationAsNull = false,
    ActivityStatusDto? statusDto,
  }) async {
    try {
      final docRef = getRacesRef(userId).doc(raceId);
      final Map<String, dynamic> jsonToUpdate = createRaceJsonToUpdate(
        name: name,
        date: date,
        place: place,
        distance: distance,
        expectedDuration: expectedDuration,
        setDurationAsNull: setDurationAsNull,
        statusDto: statusDto,
      );
      await asyncOrSyncCall(() => docRef.update(jsonToUpdate));
      final snapshot = await docRef.get();
      return snapshot.data();
    } on FirebaseException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    } catch (exception) {
      if (exception.toString().contains('code=not-found')) {
        throw mapFirebaseExceptionFromCodeStr('not-found');
      } else {
        rethrow;
      }
    }
  }

  Future<void> deleteRace({
    required String raceId,
    required String userId,
  }) async {
    final docRef = getRacesRef(userId).doc(raceId);
    await asyncOrSyncCall(
      () => docRef.delete(),
    );
  }

  Future<List<String>> deleteAllUserRaces({required String userId}) async {
    final competitionsRef = getRacesRef(userId);
    final WriteBatch batch = FirebaseFirestore.instance.batch();
    final snapshot = await competitionsRef.get();
    final List<String> idsOfDeletedRaces = [];
    for (final docSnapshot in snapshot.docs) {
      batch.delete(docSnapshot.reference);
      idsOfDeletedRaces.add(docSnapshot.id);
    }
    await asyncOrSyncCall(
      () => batch.commit(),
    );
    return idsOfDeletedRaces;
  }
}
