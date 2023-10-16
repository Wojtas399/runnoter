import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/interface/repository/race_repository.dart';
import 'package:runnoter/data/model/race.dart';
import 'package:runnoter/ui/cubit/races_cubit.dart';

import '../../creators/race_creator.dart';
import '../../mock/data/repository/mock_race_repository.dart';

void main() {
  final raceRepository = MockRaceRepository();
  const String userId = 'u1';

  setUpAll(() {
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
  });

  tearDown(() {
    reset(raceRepository);
  });

  group(
    'initialize',
    () {
      final List<Race> races = [
        createRace(id: 'c2', date: DateTime(2022, 4, 20)),
        createRace(id: 'c1', date: DateTime(2023, 5, 10)),
        createRace(id: 'c3', date: DateTime(2023, 6, 30)),
        createRace(id: 'c4', date: DateTime(2022, 3, 30)),
      ];
      final StreamController<List<Race>?> races$ = StreamController()
        ..add(races);

      blocTest(
        'should listen to all user races and should group and sort races by date',
        build: () => RacesCubit(userId: userId),
        setUp: () => raceRepository.mockGetRacesByUserId(
          racesStream: races$.stream,
        ),
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          races$.add([races[1], races[2]]);
        },
        expect: () => [
          [
            RacesFromYear(year: 2023, elements: [races[2], races[1]]),
            RacesFromYear(year: 2022, elements: [races.first, races.last]),
          ],
          [
            RacesFromYear(year: 2023, elements: [races[2], races[1]]),
          ],
        ],
        verify: (_) => verify(
          () => raceRepository.getRacesByUserId(userId: userId),
        ).called(1),
      );
    },
  );

  blocTest(
    'refresh, '
    'should call race repository method to refresh all user races',
    build: () => RacesCubit(userId: userId),
    setUp: () => raceRepository.mockRefreshRacesByUserId(),
    act: (cubit) => cubit.refresh(),
    expect: () => [],
    verify: (_) => verify(
      () => raceRepository.refreshRacesByUserId(userId: userId),
    ).called(1),
  );
}
