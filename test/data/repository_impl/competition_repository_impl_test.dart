import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/competition_repository_impl.dart';
import 'package:runnoter/domain/entity/competition.dart';
import 'package:runnoter/domain/entity/run_status.dart';

import '../../creators/competition_creator.dart';
import '../../mock/firebase/mock_firebase_competition_service.dart';

void main() {
  final firebaseCompetitionService = MockFirebaseCompetitionService();
  late CompetitionRepositoryImpl repository;
  const String userId = 'u1';

  CompetitionRepositoryImpl createRepository({
    List<Competition>? initialData,
  }) =>
      CompetitionRepositoryImpl(
        firebaseCompetitionService: firebaseCompetitionService,
        initialData: initialData,
      );

  test(
    'add new competition, '
    'should call method from firebase service to add new competition and should add this new competition to repository',
    () {
      const String competitionId = 'c1';
      const String name = 'competition 1';
      final DateTime date = DateTime(2023, 5, 10);
      const String place = 'New York';
      const double distance = 21.100;
      const Time expectedTime = Time(hour: 1, minute: 30, second: 21);
      const TimeDto expectedTimeDto = TimeDto(hour: 1, minute: 30, second: 21);
      const RunStatus status = RunStatusPending();
      const RunStatusDto statusDto = RunStatusPendingDto();
      final Competition addedCompetition = Competition(
        id: competitionId,
        userId: userId,
        name: name,
        date: date,
        place: place,
        distance: distance,
        expectedTime: expectedTime,
        status: status,
      );
      final CompetitionDto addedCompetitionDto = CompetitionDto(
        id: competitionId,
        userId: userId,
        name: name,
        date: date,
        place: place,
        distance: distance,
        expectedTimeDto: expectedTimeDto,
        runStatusDto: statusDto,
      );
      final List<Competition> existingCompetitions = [
        createCompetition(id: 'c2', userId: 'u2'),
        createCompetition(id: 'c3', userId: userId),
      ];
      firebaseCompetitionService.mockAddNewCompetition(
        addedCompetitionDto: addedCompetitionDto,
      );
      repository = createRepository(initialData: existingCompetitions);

      final Stream<List<Competition>?> repositoryState$ =
          repository.dataStream$;
      repository.addNewCompetition(
        userId: userId,
        name: name,
        date: date,
        place: place,
        distance: distance,
        expectedTime: expectedTime,
        status: status,
      );

      expect(
        repositoryState$,
        emitsInOrder(
          [
            existingCompetitions,
            [
              ...existingCompetitions,
              addedCompetition,
            ],
          ],
        ),
      );
      verify(
        () => firebaseCompetitionService.addNewCompetition(
          userId: userId,
          name: name,
          date: date,
          place: place,
          distance: distance,
          expectedTimeDto: expectedTimeDto,
          runStatusDto: statusDto,
        ),
      ).called(1);
    },
  );
}
