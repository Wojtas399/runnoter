import '../entity/competition.dart';
import '../entity/run_status.dart';

abstract interface class CompetitionRepository {
  Future<void> addNewCompetition({
    required String userId,
    required String name,
    required DateTime date,
    required String place,
    required double distance,
    required Time expectedTime,
    required RunStatus status,
  });
}
