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

  void mockDeleteCompetition() {
    when(
      () => deleteCompetition(
        competitionId: any(named: 'competitionId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }
}
