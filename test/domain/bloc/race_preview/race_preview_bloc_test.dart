import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/race_preview/race_preview_bloc.dart';
import 'package:runnoter/domain/entity/race.dart';
import 'package:runnoter/domain/repository/race_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../creators/race_creator.dart';
import '../../../mock/domain/repository/mock_race_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final raceRepository = MockRaceRepository();
  const String userId = 'u1';
  const String raceId = 'r1';

  RacePreviewBloc createBloc({
    String? raceId,
    Race? race,
  }) =>
      RacePreviewBloc(
        userId: userId,
        raceId: raceId,
        state: RacePreviewState(
          status: const BlocStatusInitial(),
          race: race,
        ),
      );

  RacePreviewState createState({
    BlocStatus status = const BlocStatusInitial(),
    bool canEditRaceStatus = true,
    Race? race,
  }) =>
      RacePreviewState(
        status: status,
        canEditRaceStatus: canEditRaceStatus,
        race: race,
      );

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
  });

  tearDown(() {
    reset(authService);
    reset(raceRepository);
  });

  blocTest(
    'initialize, '
    'race id is null, '
    'should do nothing',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const RacePreviewEventInitialize()),
    expect: () => [],
  );

  group(
    'initialize',
    () {
      final Race race = createRace(id: 'r1', name: 'race');
      final Race updatedRace = createRace(id: 'r1', name: 'updated race');
      final StreamController<Race?> race1$ = StreamController()..add(race);
      final StreamController<Race?> race2$ = StreamController()..add(race);

      blocTest(
        'should set canEditRaceStatus param as true if user id is equal to logged user id and '
        'should set listener of race matching to given id',
        build: () => createBloc(raceId: raceId),
        setUp: () {
          authService.mockGetLoggedUserId(userId: userId);
          raceRepository.mockGetRaceById(raceStream: race1$.stream);
        },
        act: (bloc) async {
          bloc.add(const RacePreviewEventInitialize());
          await bloc.stream.first;
          race1$.add(updatedRace);
        },
        expect: () => [
          createState(
            status: const BlocStatusComplete(),
            canEditRaceStatus: true,
            race: race,
          ),
          createState(
            status: const BlocStatusComplete(),
            canEditRaceStatus: true,
            race: updatedRace,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => raceRepository.getRaceById(raceId: raceId, userId: userId),
          ).called(1);
        },
      );

      blocTest(
        'should set canEditRaceStatus param as false if user id is not equal to logged user id',
        build: () => createBloc(raceId: raceId),
        setUp: () {
          authService.mockGetLoggedUserId(userId: 'u2');
          raceRepository.mockGetRaceById(raceStream: race2$.stream);
        },
        act: (bloc) => bloc.add(const RacePreviewEventInitialize()),
        expect: () => [
          createState(
            status: const BlocStatusComplete(),
            canEditRaceStatus: false,
            race: race,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => raceRepository.getRaceById(raceId: raceId, userId: userId),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'delete race, '
    'race is null, '
    'should do nothing',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const RacePreviewEventDeleteRace()),
    expect: () => [],
  );

  blocTest(
    'delete race, '
    'should call method from race repository to delete race, '
    'should emit info that race has been deleted',
    build: () => createBloc(race: createRace(id: 'c1')),
    setUp: () => raceRepository.mockDeleteRace(),
    act: (bloc) => bloc.add(const RacePreviewEventDeleteRace()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        race: createRace(id: 'c1'),
      ),
      createState(
        status: const BlocStatusComplete<RacePreviewBlocInfo>(
          info: RacePreviewBlocInfo.raceDeleted,
        ),
        race: createRace(id: 'c1'),
      ),
    ],
    verify: (_) => verify(
      () => raceRepository.deleteRace(raceId: 'c1', userId: userId),
    ).called(1),
  );
}
