import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/activity_status.dart';
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

  RacePreviewBloc createBloc() => RacePreviewBloc(
        userId: userId,
        raceId: raceId,
        state: const RacePreviewState(status: BlocStatusInitial()),
      );

  setUpAll(() {
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
  });

  tearDown(() {
    reset(raceRepository);
  });

  group(
    'initialize',
    () {
      final Race race = createRace(
        id: 'r1',
        name: 'race',
        date: DateTime(2023, 1, 2),
        place: 'place',
        distance: 21,
        expectedDuration: const Duration(hours: 1),
        status: const ActivityStatusPending(),
      );
      final Race updatedRace = createRace(
        id: 'r1',
        name: 'updated race',
        date: DateTime(2023, 2, 1),
        place: 'update place name',
        distance: 21.5,
        expectedDuration: const Duration(hours: 1, minutes: 30),
        status: const ActivityStatusUndone(),
      );
      final StreamController<Race?> race$ = StreamController()..add(race);

      blocTest(
        'should set listener of race matching to given id',
        build: () => createBloc(),
        setUp: () => raceRepository.mockGetRaceById(raceStream: race$.stream),
        act: (bloc) async {
          bloc.add(const RacePreviewEventInitialize());
          await bloc.stream.first;
          race$.add(updatedRace);
        },
        expect: () => [
          RacePreviewState(
            status: const BlocStatusComplete(),
            name: race.name,
            date: race.date,
            place: race.place,
            distance: race.distance,
            expectedDuration: race.expectedDuration,
            raceStatus: race.status,
          ),
          RacePreviewState(
            status: const BlocStatusComplete(),
            name: updatedRace.name,
            date: updatedRace.date,
            place: updatedRace.place,
            distance: updatedRace.distance,
            expectedDuration: updatedRace.expectedDuration,
            raceStatus: updatedRace.status,
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
    'should call method from race repository to delete race, '
    'should emit info that race has been deleted',
    build: () => createBloc(),
    setUp: () => raceRepository.mockDeleteRace(),
    act: (bloc) => bloc.add(const RacePreviewEventDeleteRace()),
    expect: () => [
      const RacePreviewState(status: BlocStatusLoading()),
      const RacePreviewState(
        status: BlocStatusComplete<RacePreviewBlocInfo>(
          info: RacePreviewBlocInfo.raceDeleted,
        ),
      ),
    ],
    verify: (_) => verify(
      () => raceRepository.deleteRace(raceId: raceId, userId: userId),
    ).called(1),
  );
}
