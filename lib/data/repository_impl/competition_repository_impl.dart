import 'package:firebase/firebase.dart';
import 'package:firebase/service/firebase_competition_service.dart';

import '../../domain/additional_model/state_repository.dart';
import '../../domain/entity/competition.dart';
import '../../domain/entity/run_status.dart';
import '../../domain/repository/competition_repository.dart';
import '../mapper/competition_mapper.dart';
import '../mapper/run_status_mapper.dart';

class CompetitionRepositoryImpl extends StateRepository<Competition>
    implements CompetitionRepository {
  final FirebaseCompetitionService _firebaseCompetitionService;

  CompetitionRepositoryImpl({
    required FirebaseCompetitionService firebaseCompetitionService,
    super.initialData,
  }) : _firebaseCompetitionService = firebaseCompetitionService;

  @override
  Future<void> addNewCompetition({
    required String userId,
    required String name,
    required DateTime date,
    required String place,
    required double distance,
    required Duration expectedDuration,
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
      runStatusDto: mapRunStatusToDto(status),
    );
    if (addedCompetitionDto != null) {
      final Competition competition = mapCompetitionFromDto(
        addedCompetitionDto,
      );
      addEntity(competition);
    }
  }
}
