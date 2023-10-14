import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart';

import '../../common/date_service.dart';
import '../../dependency_injection.dart';
import '../../domain/additional_model/state_repository.dart';
import '../additional_model/activity_status.dart';
import '../entity/race.dart';
import '../interface/repository/race_repository.dart';
import '../mapper/activity_status_mapper.dart';
import '../mapper/custom_exception_mapper.dart';
import '../mapper/race_mapper.dart';

class RaceRepositoryImpl extends StateRepository<Race>
    implements RaceRepository {
  final FirebaseRaceService _dbRaceService;
  final DateService _dateService;

  RaceRepositoryImpl({
    super.initialData,
  })  : _dbRaceService = getIt<FirebaseRaceService>(),
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
      race ??= await _loadRaceFromDb(raceId, userId);
      yield race;
    }
  }

  @override
  Stream<List<Race>?> getRacesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) async* {
    final racesLoadedFromDb =
        await _loadRacesByDateRangeFromDb(startDate, endDate, userId);
    if (racesLoadedFromDb?.isNotEmpty == true) {
      addOrUpdateEntities(racesLoadedFromDb!);
    }
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
    await _loadRacesByDateFromDb(date, userId);
    await for (final races in dataStream$) {
      yield races
          ?.where(
            (race) =>
                race.userId == userId &&
                _dateService.areDaysTheSame(race.date, date),
          )
          .toList();
    }
  }

  @override
  Stream<List<Race>?> getRacesByUserId({required String userId}) async* {
    final racesLoadedFromDb = await _loadRacesByUserIdFromDb(userId);
    if (racesLoadedFromDb?.isNotEmpty == true) {
      addOrUpdateEntities(racesLoadedFromDb!);
    }
    await for (final races in dataStream$) {
      yield races?.where((race) => race.userId == userId).toList();
    }
  }

  @override
  Future<void> refreshRacesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) async {
    final existingRaces = await dataStream$.first;
    final racesLoadedFromDb =
        await _loadRacesByDateRangeFromDb(startDate, endDate, userId);
    final List<Race> updatedRaces = [
      ...?existingRaces?.where(
        (race) =>
            race.userId != userId ||
            !_dateService.isDateFromRange(
              date: race.date,
              startDate: startDate,
              endDate: endDate,
            ),
      ),
      ...?racesLoadedFromDb,
    ];
    setEntities(updatedRaces);
  }

  @override
  Future<void> refreshRacesByUserId({required String userId}) async {
    final existingRaces = await dataStream$.first;
    final userRacesLoadedFromDb = await _loadRacesByUserIdFromDb(userId);
    final List<Race> updatedRaces = [
      ...?existingRaces?.where((race) => race.userId != userId),
      ...?userRacesLoadedFromDb,
    ];
    setEntities(updatedRaces);
  }

  @override
  Future<void> addNewRace({
    required String userId,
    required String name,
    required DateTime date,
    required String place,
    required double distance,
    required Duration? expectedDuration,
    required ActivityStatus status,
  }) async {
    final RaceDto? addedRaceDto = await _dbRaceService.addNewRace(
      userId: userId,
      name: name,
      date: date,
      place: place,
      distance: distance,
      expectedDuration: expectedDuration,
      statusDto: mapActivityStatusToDto(status),
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
    ActivityStatus? status,
  }) async {
    try {
      final RaceDto? updatedRaceDto = await _dbRaceService.updateRace(
        raceId: raceId,
        userId: userId,
        name: name,
        date: date,
        place: place,
        distance: distance,
        expectedDuration: expectedDuration,
        setDurationAsNull: setDurationAsNull,
        statusDto: status != null ? mapActivityStatusToDto(status) : null,
      );
      if (updatedRaceDto != null) {
        final Race race = mapRaceFromDto(updatedRaceDto);
        updateEntity(race);
      }
    } on FirebaseDocumentException catch (documentException) {
      if (documentException.code ==
          FirebaseDocumentExceptionCode.documentNotFound) {
        removeEntity(raceId);
      }
      throw mapExceptionFromDb(documentException);
    }
  }

  @override
  Future<void> deleteRace({
    required String raceId,
    required String userId,
  }) async {
    await _dbRaceService.deleteRace(
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
        await _dbRaceService.deleteAllUserRaces(
      userId: userId,
    );
    removeEntities(idsOfDeletedRaces);
  }

  Future<Race?> _loadRaceFromDb(String raceId, String userId) async {
    final RaceDto? raceDto = await _dbRaceService.loadRaceById(
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

  Future<List<Race>?> _loadRacesByDateRangeFromDb(
    DateTime startDate,
    DateTime endDate,
    String userId,
  ) async {
    final List<RaceDto>? raceDtos = await _dbRaceService.loadRacesByDateRange(
      startDate: startDate,
      endDate: endDate,
      userId: userId,
    );
    return raceDtos?.map(mapRaceFromDto).toList();
  }

  Future<void> _loadRacesByDateFromDb(DateTime date, String userId) async {
    final List<RaceDto>? raceDtos = await _dbRaceService.loadRacesByDate(
      date: date,
      userId: userId,
    );
    if (raceDtos != null) {
      final List<Race> races = raceDtos.map(mapRaceFromDto).toList();
      addOrUpdateEntities(races);
    }
  }

  Future<List<Race>?> _loadRacesByUserIdFromDb(String userId) async {
    final raceDtos = await _dbRaceService.loadRacesByUserId(userId: userId);
    return raceDtos?.map(mapRaceFromDto).toList();
  }
}
