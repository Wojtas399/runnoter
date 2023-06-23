import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/service/firebase_competition_service.dart';

import '../../common/date_service.dart';
import '../../domain/additional_model/state_repository.dart';
import '../../domain/entity/competition.dart';
import '../../domain/entity/run_status.dart';
import '../../domain/repository/competition_repository.dart';
import '../mapper/competition_mapper.dart';
import '../mapper/run_status_mapper.dart';

class CompetitionRepositoryImpl extends StateRepository<Competition>
    implements CompetitionRepository {
  final FirebaseCompetitionService _firebaseCompetitionService;
  final DateService _dateService;

  CompetitionRepositoryImpl({
    required FirebaseCompetitionService firebaseCompetitionService,
    required DateService dateService,
    super.initialData,
  })  : _firebaseCompetitionService = firebaseCompetitionService,
        _dateService = dateService;

  @override
  Stream<Competition?> getCompetitionById({
    required String competitionId,
    required String userId,
  }) async* {
    await for (final competitions in dataStream$) {
      Competition? competition = competitions?.firstWhereOrNull(
        (elem) => elem.id == competitionId && elem.userId == userId,
      );
      competition ??= await _loadCompetitionFromRemoteDb(competitionId, userId);
      yield competition;
    }
  }

  @override
  Stream<List<Competition>?> getCompetitionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) async* {
    await _loadCompetitionsByDateRangeFromRemoteDb(startDate, endDate, userId);
    await for (final competitions in dataStream$) {
      yield competitions
          ?.where(
            (competition) =>
                competition.userId == userId &&
                _dateService.isDateFromRange(
                  date: competition.date,
                  startDate: startDate,
                  endDate: endDate,
                ),
          )
          .toList();
    }
  }

  @override
  Stream<List<Competition>?> getCompetitionsByDate({
    required DateTime date,
    required String userId,
  }) async* {
    await _loadCompetitionsByDateFromRemoteDb(date, userId);
    await for (final competitions in dataStream$) {
      yield competitions
          ?.where(
            (competition) =>
                competition.userId == userId &&
                _dateService.areDatesTheSame(competition.date, date),
          )
          .toList();
    }
  }

  @override
  Stream<List<Competition>?> getAllCompetitions({
    required String userId,
  }) async* {
    await _loadAllCompetitionsFromRemoteDb(userId);
    await for (final competitions in dataStream$) {
      yield competitions
          ?.where((competition) => competition.userId == userId)
          .toList();
    }
  }

  @override
  Future<void> addNewCompetition({
    required String userId,
    required String name,
    required DateTime date,
    required String place,
    required double distance,
    required Duration? expectedDuration,
    required RunStatus status,
  }) async {
    final CompetitionDto? addedCompetitionDto =
        await _firebaseCompetitionService.addNewCompetition(
      userId: userId,
      name: name,
      date: date,
      place: place,
      distance: distance,
      expectedDuration: expectedDuration,
      statusDto: mapRunStatusToDto(status),
    );
    if (addedCompetitionDto != null) {
      final Competition competition = mapCompetitionFromDto(
        addedCompetitionDto,
      );
      addEntity(competition);
    }
  }

  @override
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
  }) async {
    final CompetitionDto? updatedCompetitionDto =
        await _firebaseCompetitionService.updateCompetition(
      competitionId: competitionId,
      userId: userId,
      name: name,
      date: date,
      place: place,
      distance: distance,
      expectedDuration: expectedDuration,
      setDurationAsNull: setDurationAsNull,
      statusDto: status != null ? mapRunStatusToDto(status) : null,
    );
    if (updatedCompetitionDto != null) {
      final Competition competition = mapCompetitionFromDto(
        updatedCompetitionDto,
      );
      updateEntity(competition);
    }
  }

  @override
  Future<void> deleteCompetition({
    required String competitionId,
    required String userId,
  }) async {
    await _firebaseCompetitionService.deleteCompetition(
      competitionId: competitionId,
      userId: userId,
    );
    removeEntity(competitionId);
  }

  @override
  Future<void> deleteAllUserCompetitions({
    required String userId,
  }) async {
    final List<String> idsOfDeletedCompetitions =
        await _firebaseCompetitionService.deleteAllUserCompetitions(
      userId: userId,
    );
    removeEntities(idsOfDeletedCompetitions);
  }

  Future<Competition?> _loadCompetitionFromRemoteDb(
    String competitionId,
    String userId,
  ) async {
    final CompetitionDto? competitionDto =
        await _firebaseCompetitionService.loadCompetitionById(
      competitionId: competitionId,
      userId: userId,
    );
    if (competitionDto != null) {
      final Competition competition = mapCompetitionFromDto(competitionDto);
      addEntity(competition);
      return competition;
    }
    return null;
  }

  Future<void> _loadCompetitionsByDateRangeFromRemoteDb(
    DateTime startDate,
    DateTime endDate,
    String userId,
  ) async {
    final List<CompetitionDto>? competitionDtos =
        await _firebaseCompetitionService.loadCompetitionsByDateRange(
      startDate: startDate,
      endDate: endDate,
      userId: userId,
    );
    if (competitionDtos != null) {
      final List<Competition> competitions =
          competitionDtos.map(mapCompetitionFromDto).toList();
      addEntities(competitions);
    }
  }

  Future<void> _loadCompetitionsByDateFromRemoteDb(
    DateTime date,
    String userId,
  ) async {
    final List<CompetitionDto>? competitionDtos =
        await _firebaseCompetitionService.loadCompetitionsByDate(
      date: date,
      userId: userId,
    );
    if (competitionDtos != null) {
      final List<Competition> competitions =
          competitionDtos.map(mapCompetitionFromDto).toList();
      addEntities(competitions);
    }
  }

  Future<void> _loadAllCompetitionsFromRemoteDb(String userId) async {
    final List<CompetitionDto>? competitionDtos =
        await _firebaseCompetitionService.loadAllCompetitions(userId: userId);
    if (competitionDtos != null) {
      final List<Competition> competitions =
          competitionDtos.map(mapCompetitionFromDto).toList();
      addEntities(competitions);
    }
  }
}
