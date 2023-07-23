import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/service/firebase_race_service.dart';

import '../../common/date_service.dart';
import '../../dependency_injection.dart';
import '../../domain/additional_model/state_repository.dart';
import '../../domain/entity/race.dart';
import '../../domain/entity/run_status.dart';
import '../../domain/repository/race_repository.dart';
import '../mapper/race_mapper.dart';
import '../mapper/run_status_mapper.dart';

class RaceRepositoryImpl extends StateRepository<Race>
    implements RaceRepository {
  final FirebaseRaceService _firebaseRaceService;
  final DateService _dateService;

  RaceRepositoryImpl({
    required FirebaseRaceService firebaseRaceService,
    super.initialData,
  })  : _firebaseRaceService = firebaseRaceService,
        _dateService = getIt<DateService>();

  @override
  Stream<Race?> getRaceById({
    required String raceId,
    required String userId,
  }) async* {
    await for (final races in dataStream$) {
      Race? race = races?.firstWhereOrNull(
        (elem) => elem.id == raceId && elem.userId == userId,
      );
      race ??= await _loadRaceFromRemoteDb(raceId, userId);
      yield race;
    }
  }

  @override
  Stream<List<Race>?> getRacesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) async* {
    await _loadRacesByDateRangeFromRemoteDb(startDate, endDate, userId);
    await for (final races in dataStream$) {
      yield races
          ?.where(
            (race) =>
                race.userId == userId &&
                _dateService.isDateFromRange(
                  date: race.date,
                  startDate: startDate,
                  endDate: endDate,
                ),
          )
          .toList();
    }
  }

  @override
  Stream<List<Race>?> getRacesByDate({
    required DateTime date,
    required String userId,
  }) async* {
    await _loadRacesByDateFromRemoteDb(date, userId);
    await for (final races in dataStream$) {
      yield races
          ?.where(
            (race) =>
                race.userId == userId &&
                _dateService.areDatesTheSame(race.date, date),
          )
          .toList();
    }
  }

  @override
  Stream<List<Race>?> getAllRaces({
    required String userId,
  }) async* {
    await _loadAllRacesFromRemoteDb(userId);
    await for (final races in dataStream$) {
      yield races?.where((race) => race.userId == userId).toList();
    }
  }

  @override
  Future<void> addNewRace({
    required String userId,
    required String name,
    required DateTime date,
    required String place,
    required double distance,
    required Duration? expectedDuration,
    required RunStatus status,
  }) async {
    final RaceDto? addedRaceDto = await _firebaseRaceService.addNewRace(
      userId: userId,
      name: name,
      date: date,
      place: place,
      distance: distance,
      expectedDuration: expectedDuration,
      statusDto: mapRunStatusToDto(status),
    );
    if (addedRaceDto != null) {
      final Race race = mapRaceFromDto(
        addedRaceDto,
      );
      addEntity(race);
    }
  }

  @override
  Future<void> updateRace({
    required String raceId,
    required String userId,
    String? name,
    DateTime? date,
    String? place,
    double? distance,
    Duration? expectedDuration,
    bool setDurationAsNull = false,
    RunStatus? status,
  }) async {
    final RaceDto? updatedRaceDto = await _firebaseRaceService.updateRace(
      raceId: raceId,
      userId: userId,
      name: name,
      date: date,
      place: place,
      distance: distance,
      expectedDuration: expectedDuration,
      setDurationAsNull: setDurationAsNull,
      statusDto: status != null ? mapRunStatusToDto(status) : null,
    );
    if (updatedRaceDto != null) {
      final Race race = mapRaceFromDto(
        updatedRaceDto,
      );
      updateEntity(race);
    }
  }

  @override
  Future<void> deleteRace({
    required String raceId,
    required String userId,
  }) async {
    await _firebaseRaceService.deleteRace(
      raceId: raceId,
      userId: userId,
    );
    removeEntity(raceId);
  }

  @override
  Future<void> deleteAllUserRaces({
    required String userId,
  }) async {
    final List<String> idsOfDeletedRaces =
        await _firebaseRaceService.deleteAllUserRaces(
      userId: userId,
    );
    removeEntities(idsOfDeletedRaces);
  }

  Future<Race?> _loadRaceFromRemoteDb(
    String raceId,
    String userId,
  ) async {
    final RaceDto? raceDto = await _firebaseRaceService.loadRaceById(
      raceId: raceId,
      userId: userId,
    );
    if (raceDto != null) {
      final Race race = mapRaceFromDto(raceDto);
      addEntity(race);
      return race;
    }
    return null;
  }

  Future<void> _loadRacesByDateRangeFromRemoteDb(
    DateTime startDate,
    DateTime endDate,
    String userId,
  ) async {
    final List<RaceDto>? raceDtos =
        await _firebaseRaceService.loadRacesByDateRange(
      startDate: startDate,
      endDate: endDate,
      userId: userId,
    );
    if (raceDtos != null) {
      final List<Race> races = raceDtos.map(mapRaceFromDto).toList();
      addEntities(races);
    }
  }

  Future<void> _loadRacesByDateFromRemoteDb(
    DateTime date,
    String userId,
  ) async {
    final List<RaceDto>? raceDtos = await _firebaseRaceService.loadRacesByDate(
      date: date,
      userId: userId,
    );
    if (raceDtos != null) {
      final List<Race> races = raceDtos.map(mapRaceFromDto).toList();
      addEntities(races);
    }
  }

  Future<void> _loadAllRacesFromRemoteDb(String userId) async {
    final List<RaceDto>? raceDtos =
        await _firebaseRaceService.loadAllRaces(userId: userId);
    if (raceDtos != null) {
      final List<Race> races = raceDtos.map(mapRaceFromDto).toList();
      addEntities(races);
    }
  }
}
