import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/competition.dart';
import 'package:runnoter/domain/entity/run_status.dart';
import 'package:runnoter/domain/repository/competition_repository.dart';

class _FakeTime extends Fake implements Time {}

class _FakeRunStatus extends Fake implements RunStatus {}

class MockCompetitionRepository extends Mock implements CompetitionRepository {
  void mockAddNewCompetition() {
    _mockTime();
    _mockRunStatus();
    when(
      () => addNewCompetition(
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        date: any(named: 'date'),
        place: any(named: 'place'),
        distance: any(named: 'distance'),
        expectedTime: any(named: 'expectedTime'),
        status: any(named: 'status'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void _mockTime() {
    registerFallbackValue(_FakeTime());
  }

  void _mockRunStatus() {
    registerFallbackValue(_FakeRunStatus());
  }
}
