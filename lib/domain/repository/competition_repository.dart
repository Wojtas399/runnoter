import '../entity/competition.dart';
import '../entity/run_status.dart';

abstract interface class CompetitionRepository {
  Stream<Competition?> getCompetitionById({
    required String competitionId,
    required String userId,
  });

  Stream<List<Competition>?> getAllCompetitions({
    required String userId,
  });

  Future<void> addNewCompetition({
    required String userId,
    required String name,
    required DateTime date,
    required String place,
    required double distance,
    required Duration? expectedDuration,
    required RunStatus status,
  });

  Future<void> updateCompetition({
    required String competitionId,
    required String userId,
    String? name,
    DateTime? date,
    String? place,
    double? distance,
    Duration? expectedDuration,
    bool setDurationAsNull = false,
    RunStatus? status,
  });

  Future<void> deleteCompetition({
    required String competitionId,
    required String userId,
  });
}
