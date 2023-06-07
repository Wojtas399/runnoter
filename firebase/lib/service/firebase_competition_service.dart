import '../firebase_collections.dart';
import '../model/competition_dto.dart';
import '../model/run_status_dto.dart';

class FirebaseCompetitionService {
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
}
