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
        runStatusDto: any(named: 'runStatusDto'),
      ),
    ).thenAnswer((invocation) => Future.value(addedCompetitionDto));
  }
}
