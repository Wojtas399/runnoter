import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/competition.dart';
import 'package:runnoter/domain/entity/run_status.dart';
import 'package:runnoter/domain/repository/competition_repository.dart';

class _FakeDuration extends Fake implements Duration {}

class _FakeRunStatus extends Fake implements RunStatus {}

class MockCompetitionRepository extends Mock implements CompetitionRepository {
  MockCompetitionRepository() {
    registerFallbackValue(_FakeDuration());
    registerFallbackValue(_FakeRunStatus());
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
}
