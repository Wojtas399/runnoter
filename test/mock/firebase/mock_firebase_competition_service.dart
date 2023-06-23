import 'package:firebase/firebase.dart';
import 'package:firebase/service/firebase_competition_service.dart';
import 'package:mocktail/mocktail.dart';

class _FakeDuration extends Fake implements Duration {}

class _FakeRunStatusDto extends Fake implements RunStatusDto {}

class MockFirebaseCompetitionService extends Mock
    implements FirebaseCompetitionService {
  MockFirebaseCompetitionService() {
    registerFallbackValue(_FakeDuration());
    registerFallbackValue(_FakeRunStatusDto());
  }

  void mockLoadCompetitionById({
    CompetitionDto? competitionDto,
  }) {
    when(
      () => loadCompetitionById(
        competitionId: any(named: 'competitionId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(competitionDto));
  }

  void mockLoadCompetitionsByDateRange({
    List<CompetitionDto>? competitionDtos,
  }) {
    when(
      () => loadCompetitionsByDateRange(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(competitionDtos));
  }

  void mockLoadCompetitionsByDate({
    List<CompetitionDto>? competitionDtos,
  }) {
    when(
      () => loadCompetitionsByDate(
        date: any(named: 'date'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(competitionDtos));
  }

  void mockLoadAllCompetitions({
    List<CompetitionDto>? competitionDtos,
  }) {
    when(
      () => loadAllCompetitions(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(competitionDtos));
  }

  void mockAddNewCompetition({
    CompetitionDto? addedCompetitionDto,
  }) {
    when(
      () => addNewCompetition(
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        date: any(named: 'date'),
        place: any(named: 'place'),
        distance: any(named: 'distance'),
        expectedDuration: any(named: 'expectedDuration'),
        statusDto: any(named: 'statusDto'),
      ),
    ).thenAnswer((invocation) => Future.value(addedCompetitionDto));
  }

  void mockUpdateCompetition({
    CompetitionDto? updatedCompetitionDto,
  }) {
    when(
      () => updateCompetition(
        competitionId: any(named: 'competitionId'),
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        date: any(named: 'date'),
        place: any(named: 'place'),
        distance: any(named: 'distance'),
        expectedDuration: any(named: 'expectedDuration'),
        setDurationAsNull: any(named: 'setDurationAsNull'),
        statusDto: any(named: 'statusDto'),
      ),
    ).thenAnswer((invocation) => Future.value(updatedCompetitionDto));
  }

  void mockDeleteCompetition() {
    when(
      () => deleteCompetition(
        competitionId: any(named: 'competitionId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockDeleteAllUserCompetitions({
    required List<String> idsOfDeletedCompetitions,
  }) {
    when(
      () => deleteAllUserCompetitions(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(idsOfDeletedCompetitions));
  }
}
