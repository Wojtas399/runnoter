import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/repository/competition_repository.dart';

class MockCompetitionRepository extends Mock implements CompetitionRepository {
  void mockAddNewCompetition() {
    when(
      () => addNewCompetition(
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        date: any(named: 'date'),
        place: any(named: 'place'),
        distance: any(named: 'distance'),
        expectedTime: any(named: 'expectedTime'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }
}
