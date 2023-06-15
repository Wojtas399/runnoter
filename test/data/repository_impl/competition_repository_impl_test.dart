import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/competition_repository_impl.dart';
import 'package:runnoter/domain/entity/competition.dart';
import 'package:runnoter/domain/entity/run_status.dart';

import '../../creators/competition_creator.dart';
import '../../creators/competition_dto_creator.dart';
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
    'get competition by id, '
    'competition exists in repository, '
    'should emit matching competition',
    () {
      const String competitionId = 'c1';
      final Competition expectedCompetition = createCompetition(
        id: competitionId,
        userId: userId,
      );
      final List<Competition> existingCompetitions = [
        expectedCompetition,
        createCompetition(id: 'c2', userId: 'u2'),
        createCompetition(id: 'c3', userId: 'u3'),
        createCompetition(id: 'c4', userId: userId),
      ];
      repository = createRepository(initialData: existingCompetitions);

      final Stream<Competition?> competition$ = repository.getCompetitionById(
        competitionId: competitionId,
        userId: userId,
      );

      expect(
        competition$,
        emitsInOrder(
          [
            expectedCompetition,
          ],
        ),
      );
    },
  );

  test(
    'get competition by id, '
    'competition does not exist in repository, '
    'should load competition from remote db, add it to repository and emit it',
    () {
      const String competitionId = 'c1';
      final CompetitionDto expectedCompetitionDto = createCompetitionDto(
        id: competitionId,
        userId: userId,
      );
      final Competition expectedCompetition = createCompetition(
        id: competitionId,
        userId: userId,
      );
      final List<Competition> existingCompetitions = [
        createCompetition(id: 'c2', userId: 'u2'),
        createCompetition(id: 'c3', userId: 'u3'),
        createCompetition(id: 'c4', userId: userId),
      ];
      firebaseCompetitionService.mockLoadCompetitionById(
        competitionDto: expectedCompetitionDto,
      );
      repository = createRepository(initialData: existingCompetitions);

      final Stream<List<Competition>?> repositoryState$ =
          repository.dataStream$;
      final Stream<Competition?> competition$ = repository.getCompetitionById(
        competitionId: competitionId,
        userId: userId,
      );

      expect(
        repositoryState$,
        emitsInOrder(
          [
            existingCompetitions,
            [
              ...existingCompetitions,
              expectedCompetition,
            ]
          ],
        ),
      );
      expect(
        competition$,
        emitsInOrder(
          [
            expectedCompetition,
          ],
        ),
      );
    },
  );

  test(
    'get all competitions, '
    'should load all competitions belonging to user from remote db, should add them to repository and should emit them',
    () {
      final List<Competition> existingCompetitions = [
        createCompetition(id: 'c1', userId: userId),
        createCompetition(id: 'c2', userId: 'u2'),
        createCompetition(id: 'c3', userId: 'u3'),
        createCompetition(id: 'c4', userId: userId),
      ];
      final List<CompetitionDto> loadedCompetitionDtos = [
        createCompetitionDto(id: 'c5', userId: userId),
        createCompetitionDto(id: 'c6', userId: userId),
      ];
      final List<Competition> loadedCompetitions = [
        createCompetition(id: 'c5', userId: userId),
        createCompetition(id: 'c6', userId: userId),
      ];
      firebaseCompetitionService.mockLoadAllCompetitions(
        competitionDtos: loadedCompetitionDtos,
      );
      repository = createRepository(initialData: existingCompetitions);

      final Stream<List<Competition>?> competitions$ =
          repository.getAllCompetitions(userId: userId);

      expect(
        competitions$,
        emitsInOrder(
          [
            [
              existingCompetitions.first,
              existingCompetitions.last,
              ...loadedCompetitions,
            ]
          ],
        ),
      );
    },
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
      const Duration expectedDuration = Duration(
        hours: 1,
        minutes: 30,
        seconds: 21,
      );
      const RunStatus status = RunStatusPending();
      const RunStatusDto statusDto = RunStatusPendingDto();
      final Competition addedCompetition = Competition(
        id: competitionId,
        userId: userId,
        name: name,
        date: date,
        place: place,
        distance: distance,
        expectedDuration: expectedDuration,
        status: status,
      );
      final CompetitionDto addedCompetitionDto = CompetitionDto(
        id: competitionId,
        userId: userId,
        name: name,
        date: date,
        place: place,
        distance: distance,
        expectedDuration: expectedDuration,
        statusDto: statusDto,
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
        expectedDuration: expectedDuration,
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
          expectedDuration: expectedDuration,
          statusDto: statusDto,
        ),
      ).called(1);
    },
  );

  test(
    'update competition, '
    'should call method from firebase competition service to update competition and should update this competition in repository',
    () async {
      const String competitionId = 'c1';
      const String newName = 'new competition name';
      final DateTime newDate = DateTime(2023, 5, 20);
      const String newPlace = 'new competition place';
      const double newDistance = 15.0;
      const Duration newExpectedDuration = Duration(
        hours: 1,
        minutes: 30,
        seconds: 20,
      );
      const RunStatus newStatus = RunStatusPending();
      const RunStatusDto newStatusDto = RunStatusPendingDto();
      final List<Competition> existingCompetitions = [
        createCompetition(id: competitionId, userId: userId),
        createCompetition(id: 'c2', userId: 'u2'),
        createCompetition(id: 'c3', userId: 'u3'),
        createCompetition(id: 'c4', userId: userId),
      ];
      final CompetitionDto updatedCompetitionDto = createCompetitionDto(
        id: competitionId,
        userId: userId,
        name: newName,
        date: newDate,
        place: newPlace,
        distance: newDistance,
        expectedDuration: newExpectedDuration,
        status: newStatusDto,
      );
      final Competition updatedCompetition = createCompetition(
        id: competitionId,
        userId: userId,
        name: newName,
        date: newDate,
        place: newPlace,
        distance: newDistance,
        expectedDuration: newExpectedDuration,
        status: newStatus,
      );
      firebaseCompetitionService.mockUpdateCompetition(
        updatedCompetitionDto: updatedCompetitionDto,
      );
      repository = createRepository(initialData: existingCompetitions);

      final Stream<List<Competition>?> repositoryState$ =
          repository.dataStream$;
      await repository.updateCompetition(
        competitionId: competitionId,
        userId: userId,
        name: newName,
        date: newDate,
        place: newPlace,
        distance: newDistance,
        expectedDuration: newExpectedDuration,
        setDurationAsNull: true,
        status: newStatus,
      );

      expect(
        repositoryState$,
        emitsInOrder(
          [
            [
              updatedCompetition,
              ...existingCompetitions.slice(1),
            ]
          ],
        ),
      );
      verify(
        () => firebaseCompetitionService.updateCompetition(
          competitionId: competitionId,
          userId: userId,
          name: newName,
          date: newDate,
          place: newPlace,
          distance: newDistance,
          expectedDuration: newExpectedDuration,
          setDurationAsNull: true,
          statusDto: newStatusDto,
        ),
      ).called(1);
    },
  );

  test(
    'delete competition, '
    'should call method from firebase competition service to delete competition and should delete this competition from repository',
    () async {
      const String competitionId = 'c1';
      final List<Competition> existingCompetitions = [
        createCompetition(id: competitionId, userId: userId),
        createCompetition(id: 'c2', userId: 'u2'),
        createCompetition(id: 'c3', userId: 'u3'),
        createCompetition(id: 'c4', userId: userId),
      ];
      firebaseCompetitionService.mockDeleteCompetition();
      repository = createRepository(initialData: existingCompetitions);

      final Stream<List<Competition>?> repositoryState$ =
          repository.dataStream$;
      await repository.deleteCompetition(
        competitionId: competitionId,
        userId: userId,
      );

      expect(
        repositoryState$,
        emitsInOrder(
          [
            existingCompetitions.slice(1),
          ],
        ),
      );
      verify(
        () => firebaseCompetitionService.deleteCompetition(
          competitionId: competitionId,
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'delete all user competitions, '
    'should call method from firebase competition service to delete all user competitions and should delete this competitions from repository',
    () {
      final List<Competition> existingCompetitions = [
        createCompetition(id: 'c1', userId: userId),
        createCompetition(id: 'c2', userId: 'u2'),
        createCompetition(id: 'c3', userId: 'u3'),
        createCompetition(id: 'c4', userId: userId),
      ];
      firebaseCompetitionService.mockDeleteAllUserCompetitions(
        idsOfDeletedCompetitions: ['c1', 'c4'],
      );
      repository = createRepository(initialData: existingCompetitions);

      final Stream<List<Competition>?> repositoryState$ =
          repository.dataStream$;
      repository.deleteAllUserCompetitions(userId: userId);

      expect(
        repositoryState$,
        emitsInOrder(
          [
            existingCompetitions,
            [
              existingCompetitions[1],
              existingCompetitions[2],
            ]
          ],
        ),
      );
      verify(
        () => firebaseCompetitionService.deleteAllUserCompetitions(
          userId: userId,
        ),
      ).called(1);
    },
  );
}
