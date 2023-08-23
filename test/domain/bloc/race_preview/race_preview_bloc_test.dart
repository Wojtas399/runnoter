import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/race_preview/race_preview_bloc.dart';
import 'package:runnoter/domain/entity/race.dart';
import 'package:runnoter/domain/repository/race_repository.dart';

import '../../../creators/race_creator.dart';
import '../../../mock/domain/repository/mock_race_repository.dart';

void main() {
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

  setUpAll(() {
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
  });

  tearDown(() {
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
      final StreamController<Race?> race$ = StreamController()..add(race);

      blocTest(
        'should set listener of race matching to given id',
        build: () => createBloc(raceId: raceId),
        setUp: () => raceRepository.mockGetRaceById(raceStream: race$.stream),
        act: (bloc) async {
          bloc.add(const RacePreviewEventInitialize());
          await bloc.stream.first;
          race$.add(updatedRace);
        },
        expect: () => [
          RacePreviewState(status: const BlocStatusComplete(), race: race),
          RacePreviewState(
            status: const BlocStatusComplete(),
            race: updatedRace,
          ),
        ],
        verify: (_) => verify(
          () => raceRepository.getRaceById(raceId: raceId, userId: userId),
        ).called(1),
      );
    },
  );

  blocTest(
    'delete race, '
    'race id is null, '
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
      RacePreviewState(
        status: const BlocStatusLoading(),
        race: createRace(id: 'c1'),
      ),
      RacePreviewState(
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
