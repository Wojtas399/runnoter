import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/run_status.dart';
import 'package:runnoter/domain/bloc/race_creator/race_creator_bloc.dart';
import 'package:runnoter/domain/entity/race.dart';
import 'package:runnoter/domain/repository/race_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../creators/race_creator.dart';
import '../../../mock/domain/repository/mock_race_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final raceRepository = MockRaceRepository();
  const String loggedUserId = 'u1';

  RaceCreatorBloc createBloc({
    String? raceId,
    Race? race,
    String? name,
    DateTime? date,
    String? place,
    double? distance,
    Duration? expectedDuration,
  }) =>
      RaceCreatorBloc(
        raceId: raceId,
        state: RaceCreatorState(
          status: const BlocStatusInitial(),
          race: race,
          name: name,
          date: date,
          place: place,
          distance: distance,
          expectedDuration: expectedDuration,
        ),
      );

  RaceCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    Race? race,
    String? name,
    DateTime? date,
    String? place,
    double? distance,
    Duration? expectedDuration,
  }) =>
      RaceCreatorState(
        status: status,
        race: race,
        name: name,
        date: date,
        place: place,
        distance: distance,
        expectedDuration: expectedDuration,
      );

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    ;
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
  });

  tearDown(() {
    reset(authService);
    reset(raceRepository);
  });

  blocTest(
    'initialize, '
    'race id is null, '
    'should only emit given date',
    build: () => createBloc(),
    act: (bloc) => bloc.add(RaceCreatorEventInitialize(
      date: DateTime(2023, 1, 10),
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        date: DateTime(2023, 1, 10),
      ),
    ],
  );

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createBloc(raceId: 'r1'),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const RaceCreatorEventInitialize()),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'race id is not null'
    'should load race matching to given id from repository and should update all relevant params in state',
    build: () => createBloc(raceId: 'r1'),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      raceRepository.mockGetRaceById(
        race: createRace(
          id: 'r1',
          userId: loggedUserId,
          name: 'name',
          date: DateTime(2023, 6, 10),
          place: 'place',
          distance: 21,
          expectedDuration: const Duration(hours: 2),
        ),
      );
    },
    act: (bloc) => bloc.add(const RaceCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete<RaceCreatorBlocInfo>(),
        race: createRace(
          id: 'r1',
          userId: loggedUserId,
          name: 'name',
          date: DateTime(2023, 6, 10),
          place: 'place',
          distance: 21,
          expectedDuration: const Duration(hours: 2),
        ),
        name: 'name',
        date: DateTime(2023, 6, 10),
        place: 'place',
        distance: 21,
        expectedDuration: const Duration(hours: 2),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => raceRepository.getRaceById(
          raceId: 'r1',
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'name changed, '
    'should update name in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const RaceCreatorEventNameChanged(
      name: 'race name',
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        name: 'race name',
      ),
    ],
  );

  blocTest(
    'date changed, '
    'should update date in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(RaceCreatorEventDateChanged(
      date: DateTime(2023, 6, 2),
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        date: DateTime(2023, 6, 2),
      ),
    ],
  );

  blocTest(
    'place changed, '
    'should update place in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const RaceCreatorEventPlaceChanged(
      place: 'race place',
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        place: 'race place',
      ),
    ],
  );

  blocTest(
    'distance changed, '
    'should update distance in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const RaceCreatorEventDistanceChanged(
      distance: 21,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        distance: 21,
      ),
    ],
  );

  blocTest(
    'expected duration changed, '
    'should update duration in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const RaceCreatorEventExpectedDurationChanged(
      expectedDuration: Duration(hours: 1, minutes: 45, seconds: 20),
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      ),
    ],
  );

  blocTest(
    'submit, '
    'data are invalid, '
    'should do nothing',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const RaceCreatorEventSubmit()),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'race params are same as original, '
    'should do nothing',
    build: () => createBloc(
      race: createRace(
        id: 'c1',
        name: 'name',
        date: DateTime(2023),
        place: 'place',
        distance: 21,
        expectedDuration: const Duration(hours: 1),
      ),
      name: 'name',
      date: DateTime(2023),
      place: 'place',
      distance: 21,
      expectedDuration: const Duration(hours: 1),
    ),
    act: (bloc) => bloc.add(const RaceCreatorEventSubmit()),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'logged user does not exist, '
    'should emit no logged user bloc status',
    build: () => createBloc(
      name: 'race name',
      date: DateTime(2023, 6, 2),
      place: 'New York',
      distance: 21,
      expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const RaceCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'submit, '
    'add mode'
    'should call method from race repository to add new race with pending status and should emit info that race has been added',
    build: () => createBloc(
      name: 'race name',
      date: DateTime(2023, 6, 2),
      place: 'New York',
      distance: 21,
      expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      raceRepository.mockAddNewRace();
    },
    act: (bloc) => bloc.add(const RaceCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      ),
      createState(
        status: const BlocStatusComplete<RaceCreatorBlocInfo>(
          info: RaceCreatorBlocInfo.raceAdded,
        ),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => raceRepository.addNewRace(
          userId: 'u1',
          name: 'race name',
          date: DateTime(2023, 6, 2),
          place: 'New York',
          distance: 21,
          expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
          status: const RunStatusPending(),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'add mode, '
    'duration is 0'
    'should call method from race repository to add new race with duration set as null and pending status and should emit info that race has been added',
    build: () => createBloc(
      name: 'race name',
      date: DateTime(2023, 6, 2),
      place: 'New York',
      distance: 21,
      expectedDuration: const Duration(),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      raceRepository.mockAddNewRace();
    },
    act: (bloc) => bloc.add(const RaceCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(),
      ),
      createState(
        status: const BlocStatusComplete<RaceCreatorBlocInfo>(
          info: RaceCreatorBlocInfo.raceAdded,
        ),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => raceRepository.addNewRace(
          userId: 'u1',
          name: 'race name',
          date: DateTime(2023, 6, 2),
          place: 'New York',
          distance: 21,
          expectedDuration: null,
          status: const RunStatusPending(),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'edit mode, '
    'should call method from race repository to update race and should emit info that race has been updated',
    build: () => createBloc(
      race: createRace(id: 'c1'),
      name: 'race name',
      date: DateTime(2023, 6, 2),
      place: 'New York',
      distance: 21,
      expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      raceRepository.mockUpdateRace();
    },
    act: (bloc) => bloc.add(const RaceCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        race: createRace(id: 'c1'),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      ),
      createState(
        status: const BlocStatusComplete<RaceCreatorBlocInfo>(
          info: RaceCreatorBlocInfo.raceUpdated,
        ),
        race: createRace(id: 'c1'),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => raceRepository.updateRace(
          raceId: 'c1',
          userId: 'u1',
          name: 'race name',
          date: DateTime(2023, 6, 2),
          place: 'New York',
          distance: 21,
          expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'edit mode, '
    'duration is 0'
    'should call method from race repository to update race with duration set as null and should emit info that race has been updated',
    build: () => createBloc(
      race: createRace(id: 'c1'),
      name: 'race name',
      date: DateTime(2023, 6, 2),
      place: 'New York',
      distance: 21,
      expectedDuration: const Duration(),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      raceRepository.mockUpdateRace();
    },
    act: (bloc) => bloc.add(const RaceCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        race: createRace(id: 'c1'),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(),
      ),
      createState(
        status: const BlocStatusComplete<RaceCreatorBlocInfo>(
          info: RaceCreatorBlocInfo.raceUpdated,
        ),
        race: createRace(id: 'c1'),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => raceRepository.updateRace(
          raceId: 'c1',
          userId: 'u1',
          name: 'race name',
          date: DateTime(2023, 6, 2),
          place: 'New York',
          distance: 21,
          expectedDuration: null,
          setDurationAsNull: true,
        ),
      ).called(1);
    },
  );
}
