import '../additional_model/activity_status.dart';
import '../entity/race.dart';

abstract interface class RaceRepository {
  Stream<Race?> getRaceById({
    required String raceId,
    required String userId,
  });

  Stream<List<Race>?> getRacesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  });

  Stream<List<Race>?> getRacesByDate({
    required DateTime date,
    required String userId,
  });

  Stream<List<Race>?> getAllRaces({
    required String userId,
  });

  Future<void> addNewRace({
    required String userId,
    required String name,
    required DateTime date,
    required String place,
    required double distance,
    required Duration? expectedDuration,
    required ActivityStatus status,
  });

  Future<void> updateRace({
    required String raceId,
    required String userId,
    String? name,
    DateTime? date,
    String? place,
    double? distance,
    Duration? expectedDuration,
    bool setDurationAsNull = false,
    ActivityStatus? status,
  });

  Future<void> deleteRace({
    required String raceId,
    required String userId,
  });

  Future<void> deleteAllUserRaces({
    required String userId,
  });
}
