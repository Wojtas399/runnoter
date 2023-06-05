import 'package:firebase/firebase.dart';
import 'package:firebase/service/firebase_competition_service.dart';
import 'package:mocktail/mocktail.dart';

class _FakeTimeDto extends Fake implements TimeDto {}

class _FakeRunStatusDto extends Fake implements RunStatusDto {}

class MockFirebaseCompetitionService extends Mock
    implements FirebaseCompetitionService {
  void mockAddNewCompetition({
    CompetitionDto? addedCompetitionDto,
  }) {
    _mockTimeDto();
    _mockRunStatusDto();
    when(
      () => addNewCompetition(
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        date: any(named: 'date'),
        place: any(named: 'place'),
        distance: any(named: 'distance'),
        expectedTimeDto: any(named: 'expectedTimeDto'),
        runStatusDto: any(named: 'runStatusDto'),
      ),
    ).thenAnswer((invocation) => Future.value(addedCompetitionDto));
  }

  void _mockTimeDto() {
    registerFallbackValue(_FakeTimeDto());
  }

  void _mockRunStatusDto() {
    registerFallbackValue(_FakeRunStatusDto());
  }
}
