import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/data/repository_impl/race_repository_impl.dart';
import 'package:runnoter/domain/additional_model/run_status.dart';
import 'package:runnoter/domain/entity/race.dart';

import '../../creators/race_creator.dart';
import '../../creators/race_dto_creator.dart';
import '../../mock/common/mock_date_service.dart';
import '../../mock/firebase/mock_firebase_race_service.dart';

void main() {
  final firebaseRaceService = MockFirebaseRaceService();
  final dateService = MockDateService();
  late RaceRepositoryImpl repository;
  const String userId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<FirebaseRaceService>(() => firebaseRaceService);
    GetIt.I.registerFactory<DateService>(() => dateService);
  });

  tearDown(() {
    reset(firebaseRaceService);
    reset(dateService);
  });

  test(
    'get race by id, '
    'race exists in repository, '
    'should emit matching race',
    () {
      const String raceId = 'c1';
      final Race expectedRace = createRace(
        id: raceId,
        userId: userId,
      );
      final List<Race> existingRaces = [
        expectedRace,
        createRace(id: 'c2', userId: 'u2'),
        createRace(id: 'c3', userId: 'u3'),
        createRace(id: 'c4', userId: userId),
      ];
      repository = RaceRepositoryImpl(initialData: existingRaces);

      final Stream<Race?> race$ = repository.getRaceById(
        raceId: raceId,
        userId: userId,
      );

      expect(
        race$,
        emitsInOrder(
          [
            expectedRace,
          ],
        ),
      );
    },
  );

  test(
    'get race by id, '
    'race does not exist in repository, '
    'should load race from remote db, add it to repository and emit it',
    () {
      const String raceId = 'c1';
      final RaceDto expectedRaceDto = createRaceDto(
        id: raceId,
        userId: userId,
      );
      final Race expectedRace = createRace(
        id: raceId,
        userId: userId,
      );
      final List<Race> existingRaces = [
        createRace(id: 'c2', userId: 'u2'),
        createRace(id: 'c3', userId: 'u3'),
        createRace(id: 'c4', userId: userId),
      ];
      firebaseRaceService.mockLoadRaceById(
        raceDto: expectedRaceDto,
      );
      repository = RaceRepositoryImpl(initialData: existingRaces);

      final Stream<List<Race>?> repositoryState$ = repository.dataStream$;
      final Stream<Race?> race$ = repository.getRaceById(
        raceId: raceId,
        userId: userId,
      );

      expect(
        repositoryState$,
        emitsInOrder(
          [
            existingRaces,
            [
              ...existingRaces,
              expectedRace,
            ]
          ],
        ),
      );
      expect(
        race$,
        emitsInOrder(
          [
            expectedRace,
          ],
        ),
      );
    },
  );

  test(
    'get races by date range, '
    'should load all races from date range belonging to user from remote db, should add them to repository and should emit them',
    () {
      final DateTime startDate = DateTime(2023, 6, 19);
      final DateTime endDate = DateTime(2023, 6, 25);
      final List<Race> existingRaces = [
        createRace(
          id: 'c1',
          userId: userId,
          date: DateTime(2023, 6, 20),
        ),
        createRace(
          id: 'c2',
          userId: 'u2',
          date: DateTime(2023, 6, 20),
        ),
        createRace(id: 'c3', userId: 'u3'),
        createRace(id: 'c4', userId: userId),
      ];
      final List<RaceDto> loadedRaceDtos = [
        createRaceDto(
          id: 'c5',
          userId: userId,
          date: DateTime(2023, 6, 22),
        ),
        createRaceDto(
          id: 'c6',
          userId: userId,
          date: DateTime(2023, 6, 23),
        ),
      ];
      final List<Race> loadedRaces = [
        createRace(
          id: 'c5',
          userId: userId,
          date: DateTime(2023, 6, 22),
        ),
        createRace(
          id: 'c6',
          userId: userId,
          date: DateTime(2023, 6, 23),
        ),
      ];
      dateService.mockIsDateFromRange(expected: false);
      when(
        () => dateService.isDateFromRange(
          date: DateTime(2023, 6, 20),
          startDate: startDate,
          endDate: endDate,
        ),
      ).thenReturn(true);
      when(
        () => dateService.isDateFromRange(
          date: DateTime(2023, 6, 22),
          startDate: startDate,
          endDate: endDate,
        ),
      ).thenReturn(true);
      when(
        () => dateService.isDateFromRange(
          date: DateTime(2023, 6, 23),
          startDate: startDate,
          endDate: endDate,
        ),
      ).thenReturn(true);
      firebaseRaceService.mockLoadRacesByDateRange(
        raceDtos: loadedRaceDtos,
      );
      repository = RaceRepositoryImpl(initialData: existingRaces);

      final Stream<List<Race>?> races$ = repository.getRacesByDateRange(
        startDate: startDate,
        endDate: endDate,
        userId: userId,
      );

      expect(
        races$,
        emitsInOrder(
          [
            [
              existingRaces.first,
              ...loadedRaces,
            ]
          ],
        ),
      );
    },
  );

  test(
    'get races by date, '
    'should load all races by date belonging to user from remote db, should add them to repository and should emit them',
    () {
      final DateTime date = DateTime(2023, 6, 19);
      final List<Race> existingRaces = [
        createRace(
          id: 'c1',
          userId: userId,
          date: DateTime(2023, 6, 19),
        ),
        createRace(
          id: 'c2',
          userId: 'u2',
          date: DateTime(2023, 6, 19),
        ),
        createRace(id: 'c3', userId: 'u3'),
        createRace(id: 'c4', userId: userId),
      ];
      final List<RaceDto> loadedRaceDtos = [
        createRaceDto(
          id: 'c5',
          userId: userId,
          date: DateTime(2023, 6, 19),
        ),
      ];
      final List<Race> loadedRaces = [
        createRace(
          id: 'c5',
          userId: userId,
          date: DateTime(2023, 6, 19),
        ),
      ];
      dateService.mockAreDatesTheSame(expected: false);
      when(
        () => dateService.areDatesTheSame(date, date),
      ).thenReturn(true);
      firebaseRaceService.mockLoadRacesByDate(
        raceDtos: loadedRaceDtos,
      );
      repository = RaceRepositoryImpl(initialData: existingRaces);

      final Stream<List<Race>?> races$ = repository.getRacesByDate(
        date: date,
        userId: userId,
      );

      expect(
        races$,
        emitsInOrder(
          [
            [
              existingRaces.first,
              ...loadedRaces,
            ]
          ],
        ),
      );
    },
  );

  test(
    'get all races, '
    'should load all races belonging to user from remote db, should add them to repository and should emit them',
    () {
      final List<Race> existingRaces = [
        createRace(id: 'c1', userId: userId),
        createRace(id: 'c2', userId: 'u2'),
        createRace(id: 'c3', userId: 'u3'),
        createRace(id: 'c4', userId: userId),
      ];
      final List<RaceDto> loadedRaceDtos = [
        createRaceDto(id: 'c5', userId: userId),
        createRaceDto(id: 'c6', userId: userId),
      ];
      final List<Race> loadedRaces = [
        createRace(id: 'c5', userId: userId),
        createRace(id: 'c6', userId: userId),
      ];
      firebaseRaceService.mockLoadAllRaces(
        raceDtos: loadedRaceDtos,
      );
      repository = RaceRepositoryImpl(initialData: existingRaces);

      final Stream<List<Race>?> races$ = repository.getAllRaces(userId: userId);

      expect(
        races$,
        emitsInOrder(
          [
            [
              existingRaces.first,
              existingRaces.last,
              ...loadedRaces,
            ]
          ],
        ),
      );
    },
  );

  test(
    'add new race, '
    'should call method from firebase service to add new race and should add this new race to repository',
    () {
      const String raceId = 'c1';
      const String name = 'race 1';
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
      final Race addedRace = Race(
        id: raceId,
        userId: userId,
        name: name,
        date: date,
        place: place,
        distance: distance,
        expectedDuration: expectedDuration,
        status: status,
      );
      final RaceDto addedRaceDto = RaceDto(
        id: raceId,
        userId: userId,
        name: name,
        date: date,
        place: place,
        distance: distance,
        expectedDuration: expectedDuration,
        statusDto: statusDto,
      );
      final List<Race> existingRaces = [
        createRace(id: 'c2', userId: 'u2'),
        createRace(id: 'c3', userId: userId),
      ];
      firebaseRaceService.mockAddNewRace(
        addedRaceDto: addedRaceDto,
      );
      repository = RaceRepositoryImpl(initialData: existingRaces);

      final Stream<List<Race>?> repositoryState$ = repository.dataStream$;
      repository.addNewRace(
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
            existingRaces,
            [
              ...existingRaces,
              addedRace,
            ],
          ],
        ),
      );
      verify(
        () => firebaseRaceService.addNewRace(
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
    'update race, '
    'should call method from firebase race service to update race and should update this race in repository',
    () async {
      const String raceId = 'c1';
      const String newName = 'new race name';
      final DateTime newDate = DateTime(2023, 5, 20);
      const String newPlace = 'new race place';
      const double newDistance = 15.0;
      const Duration newExpectedDuration = Duration(
        hours: 1,
        minutes: 30,
        seconds: 20,
      );
      const RunStatus newStatus = RunStatusPending();
      const RunStatusDto newStatusDto = RunStatusPendingDto();
      final List<Race> existingRaces = [
        createRace(id: raceId, userId: userId),
        createRace(id: 'c2', userId: 'u2'),
        createRace(id: 'c3', userId: 'u3'),
        createRace(id: 'c4', userId: userId),
      ];
      final RaceDto updatedRaceDto = createRaceDto(
        id: raceId,
        userId: userId,
        name: newName,
        date: newDate,
        place: newPlace,
        distance: newDistance,
        expectedDuration: newExpectedDuration,
        status: newStatusDto,
      );
      final Race updatedRace = createRace(
        id: raceId,
        userId: userId,
        name: newName,
        date: newDate,
        place: newPlace,
        distance: newDistance,
        expectedDuration: newExpectedDuration,
        status: newStatus,
      );
      firebaseRaceService.mockUpdateRace(
        updatedRaceDto: updatedRaceDto,
      );
      repository = RaceRepositoryImpl(initialData: existingRaces);

      final Stream<List<Race>?> repositoryState$ = repository.dataStream$;
      await repository.updateRace(
        raceId: raceId,
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
              updatedRace,
              ...existingRaces.slice(1),
            ]
          ],
        ),
      );
      verify(
        () => firebaseRaceService.updateRace(
          raceId: raceId,
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
    'delete race, '
    'should call method from firebase race service to delete race and should delete this race from repository',
    () async {
      const String raceId = 'c1';
      final List<Race> existingRaces = [
        createRace(id: raceId, userId: userId),
        createRace(id: 'c2', userId: 'u2'),
        createRace(id: 'c3', userId: 'u3'),
        createRace(id: 'c4', userId: userId),
      ];
      firebaseRaceService.mockDeleteRace();
      repository = RaceRepositoryImpl(initialData: existingRaces);

      final Stream<List<Race>?> repositoryState$ = repository.dataStream$;
      await repository.deleteRace(
        raceId: raceId,
        userId: userId,
      );

      expect(
        repositoryState$,
        emitsInOrder(
          [
            existingRaces.slice(1),
          ],
        ),
      );
      verify(
        () => firebaseRaceService.deleteRace(
          raceId: raceId,
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'delete all user races, '
    'should call method from firebase race service to delete all user races and should delete these races from repository',
    () {
      final List<Race> existingRaces = [
        createRace(id: 'c1', userId: userId),
        createRace(id: 'c2', userId: 'u2'),
        createRace(id: 'c3', userId: 'u3'),
        createRace(id: 'c4', userId: userId),
      ];
      firebaseRaceService.mockDeleteAllUserRaces(
        idsOfDeletedRaces: ['c1', 'c4'],
      );
      repository = RaceRepositoryImpl(initialData: existingRaces);

      final Stream<List<Race>?> repositoryState$ = repository.dataStream$;
      repository.deleteAllUserRaces(userId: userId);

      expect(
        repositoryState$,
        emitsInOrder(
          [
            existingRaces,
            [
              existingRaces[1],
              existingRaces[2],
            ]
          ],
        ),
      );
      verify(
        () => firebaseRaceService.deleteAllUserRaces(
          userId: userId,
        ),
      ).called(1);
    },
  );
}
