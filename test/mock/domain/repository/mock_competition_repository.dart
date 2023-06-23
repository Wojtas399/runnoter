import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/competition.dart';
import 'package:runnoter/domain/entity/run_status.dart';
import 'package:runnoter/domain/repository/competition_repository.dart';

class _FakeDuration extends Fake implements Duration {}

class MockCompetitionRepository extends Mock implements CompetitionRepository {
  MockCompetitionRepository() {
    registerFallbackValue(_FakeDuration());
    registerFallbackValue(const RunStatusPending());
  }

  void mockGetCompetitionById({
    Competition? competition,
  }) {
    when(
      () => getCompetitionById(
        competitionId: any(named: 'competitionId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Stream.value(competition));
  }

  void mockGetCompetitionsByDateRange({
    List<Competition>? competitions,
  }) {
    when(
      () => getCompetitionsByDateRange(
        userId: any(named: 'userId'),
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      ),
    ).thenAnswer((invocation) => Stream.value(competitions));
  }

  void mockGetCompetitionsByDate({
    List<Competition>? competitions,
  }) {
    when(
      () => getCompetitionsByDate(
        date: any(named: 'date'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Stream.value(competitions));
  }

  void mockGetAllCompetitions({
    List<Competition>? competitions,
  }) {
    when(
      () => getAllCompetitions(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Stream.value(competitions));
  }

  void mockAddNewCompetition() {
    when(
      () => addNewCompetition(
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        date: any(named: 'date'),
        place: any(named: 'place'),
        distance: any(named: 'distance'),
        expectedDuration: any(named: 'expectedDuration'),
        status: any(named: 'status'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockUpdateCompetition() {
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
        status: any(named: 'status'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockDeleteCompetition() {
    when(
      () => deleteCompetition(
        competitionId: any(named: 'competitionId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockDeleteAllUserCompetitions() {
    when(
      () => deleteAllUserCompetitions(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }
}
