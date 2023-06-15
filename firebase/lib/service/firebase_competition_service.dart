import '../firebase_collections.dart';
import '../model/competition_dto.dart';
import '../model/run_status_dto.dart';

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
    final docRef = await getCompetitionsRef(userId).add(competitionDto);
    final snapshot = await docRef.get();
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
    await docRef.update(jsonToUpdate);
    final snapshot = await docRef.get();
    return snapshot.data();
  }

  Future<void> deleteCompetition({
    required String competitionId,
    required String userId,
  }) async {
    final docRef = getCompetitionsRef(userId).doc(competitionId);
    await docRef.delete();
  }
}
