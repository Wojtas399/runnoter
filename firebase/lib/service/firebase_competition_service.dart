import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_collections.dart';
import '../model/competition_dto.dart';
import '../model/run_status_dto.dart';
import '../utils/utils.dart';

class FirebaseCompetitionService {
  Future<CompetitionDto?> loadCompetitionById({
    required String competitionId,
    required String userId,
  }) async {
    final snapshot = await getCompetitionsRef(userId).doc(competitionId).get();
    return snapshot.data();
  }

  Future<List<CompetitionDto>?> loadAllCompetitions({
    required String userId,
  }) async {
    final snapshot = await getCompetitionsRef(userId).get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  Future<CompetitionDto?> addNewCompetition({
    required String userId,
    required String name,
    required DateTime date,
    required String place,
    required double distance,
    required Duration? expectedDuration,
    required RunStatusDto statusDto,
  }) async {
    final competitionRef = getCompetitionsRef(userId).doc();
    final CompetitionDto competitionDto = CompetitionDto(
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

  Future<CompetitionDto?> updateCompetition({
    required String competitionId,
    required String userId,
    String? name,
    DateTime? date,
    String? place,
    double? distance,
    Duration? expectedDuration,
    bool setDurationAsNull = false,
    RunStatusDto? statusDto,
  }) async {
    final docRef = getCompetitionsRef(userId).doc(competitionId);
    final Map<String, dynamic> jsonToUpdate = createCompetitionJsonToUpdate(
      name: name,
      date: date,
      place: place,
      distance: distance,
      expectedDuration: expectedDuration,
      setDurationAsNull: setDurationAsNull,
      statusDto: statusDto,
    );
    await asyncOrSyncCall(
      () => docRef.update(jsonToUpdate),
    );
    final snapshot = await docRef.get();
    return snapshot.data();
  }

  Future<void> deleteCompetition({
    required String competitionId,
    required String userId,
  }) async {
    final docRef = getCompetitionsRef(userId).doc(competitionId);
    await asyncOrSyncCall(
      () => docRef.delete(),
    );
  }

  Future<List<String>> deleteAllUserCompetitions({
    required String userId,
  }) async {
    final competitionsRef = getCompetitionsRef(userId);
    final WriteBatch batch = FirebaseFirestore.instance.batch();
    final snapshot = await competitionsRef.get();
    final List<String> idsOfDeletedCompetitions = [];
    for (final docSnapshot in snapshot.docs) {
      batch.delete(docSnapshot.reference);
      idsOfDeletedCompetitions.add(docSnapshot.id);
    }
    await asyncOrSyncCall(
      () => batch.commit(),
    );
    return idsOfDeletedCompetitions;
  }
}
