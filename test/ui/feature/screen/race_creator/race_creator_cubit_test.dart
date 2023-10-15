import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/additional_model/activity_status.dart';
import 'package:runnoter/data/additional_model/custom_exception.dart';
import 'package:runnoter/data/entity/race.dart';
import 'package:runnoter/data/interface/repository/race_repository.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/ui/feature/screen/race_creator/cubit/race_creator_cubit.dart';

import '../../../../creators/race_creator.dart';
import '../../../../mock/domain/repository/mock_race_repository.dart';

void main() {
  final raceRepository = MockRaceRepository();
  const String userId = 'u1';

  RaceCreatorCubit createCubit({
    String? raceId,
    Race? race,
    String? name,
    DateTime? date,
    String? place,
    double? distance,
    Duration? expectedDuration,
  }) =>
      RaceCreatorCubit(
        userId: userId,
        raceId: raceId,
        initialState: RaceCreatorState(
          status: const CubitStatusInitial(),
          race: race,
          name: name,
          date: date,
          place: place,
          distance: distance,
          expectedDuration: expectedDuration,
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
    'should only emit given date',
    build: () => createCubit(),
    act: (cubit) => cubit.initialize(DateTime(2023, 1, 10)),
    expect: () => [
      RaceCreatorState(
        status: const CubitStatusComplete(),
        date: DateTime(2023, 1, 10),
      ),
    ],
  );

  blocTest(
    'initialize, '
    'race id is not null, '
    'should load race matching to given id from repository and '
    'should update all relevant params in state',
    build: () => createCubit(raceId: 'r1'),
    setUp: () => raceRepository.mockGetRaceById(
      race: createRace(
        id: 'r1',
        userId: userId,
        name: 'name',
        date: DateTime(2023, 6, 10),
        place: 'place',
        distance: 21,
        expectedDuration: const Duration(hours: 2),
      ),
    ),
    act: (cubit) => cubit.initialize(null),
    expect: () => [
      RaceCreatorState(
        status: const CubitStatusComplete<RaceCreatorCubitInfo>(),
        race: createRace(
          id: 'r1',
          userId: userId,
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
    verify: (_) => verify(
      () => raceRepository.getRaceById(raceId: 'r1', userId: userId),
    ).called(1),
  );

  blocTest(
    'name changed, '
    'should update name in state',
    build: () => createCubit(),
    act: (cubit) => cubit.nameChanged('race name'),
    expect: () => [
      const RaceCreatorState(
        status: CubitStatusComplete(),
        name: 'race name',
      ),
    ],
  );

  blocTest(
    'date changed, '
    'should update date in state',
    build: () => createCubit(),
    act: (cubit) => cubit.dateChanged(DateTime(2023, 6, 2)),
    expect: () => [
      RaceCreatorState(
        status: const CubitStatusComplete(),
        date: DateTime(2023, 6, 2),
      ),
    ],
  );

  blocTest(
    'place changed, '
    'should update place in state',
    build: () => createCubit(),
    act: (cubit) => cubit.placeChanged('race place'),
    expect: () => [
      const RaceCreatorState(
        status: CubitStatusComplete(),
        place: 'race place',
      ),
    ],
  );

  blocTest(
    'distance changed, '
    'should update distance in state',
    build: () => createCubit(),
    act: (cubit) => cubit.distanceChanged(21),
    expect: () => [
      const RaceCreatorState(
        status: CubitStatusComplete(),
        distance: 21,
      ),
    ],
  );

  blocTest(
    'expected duration changed, '
    'should update duration in state',
    build: () => createCubit(),
    act: (cubit) => cubit.expectedDurationChanged(
      const Duration(hours: 1, minutes: 45, seconds: 20),
    ),
    expect: () => [
      const RaceCreatorState(
        status: CubitStatusComplete(),
        expectedDuration: Duration(hours: 1, minutes: 45, seconds: 20),
      ),
    ],
  );

  blocTest(
    'submit, '
    'data are invalid, '
    'should do nothing',
    build: () => createCubit(),
    act: (cubit) => cubit.submit(),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'race params are same as original, '
    'should do nothing',
    build: () => createCubit(
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
    act: (cubit) => cubit.submit(),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'race is null, '
    'should call method from race repository to add new race with pending status and '
    'should emit info that race has been added',
    build: () => createCubit(
      name: 'race name',
      date: DateTime(2023, 6, 2),
      place: 'New York',
      distance: 21,
      expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
    ),
    setUp: () => raceRepository.mockAddNewRace(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      RaceCreatorState(
        status: const CubitStatusLoading(),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      ),
      RaceCreatorState(
        status: const CubitStatusComplete<RaceCreatorCubitInfo>(
          info: RaceCreatorCubitInfo.raceAdded,
        ),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      ),
    ],
    verify: (_) => verify(
      () => raceRepository.addNewRace(
        userId: 'u1',
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
        status: const ActivityStatusPending(),
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'race is null, '
    'duration is 0, '
    'should call method from race repository to add new race with duration set as null and pending status and '
    'should emit info that race has been added',
    build: () => createCubit(
      name: 'race name',
      date: DateTime(2023, 6, 2),
      place: 'New York',
      distance: 21,
      expectedDuration: const Duration(),
    ),
    setUp: () => raceRepository.mockAddNewRace(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      RaceCreatorState(
        status: const CubitStatusLoading(),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(),
      ),
      RaceCreatorState(
        status: const CubitStatusComplete<RaceCreatorCubitInfo>(
          info: RaceCreatorCubitInfo.raceAdded,
        ),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(),
      ),
    ],
    verify: (_) => verify(
      () => raceRepository.addNewRace(
        userId: 'u1',
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: null,
        status: const ActivityStatusPending(),
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'race is not null, '
    'should call method from race repository to update race and '
    'should emit info that race has been updated',
    build: () => createCubit(
      race: createRace(id: 'c1'),
      name: 'race name',
      date: DateTime(2023, 6, 2),
      place: 'New York',
      distance: 21,
      expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
    ),
    setUp: () => raceRepository.mockUpdateRace(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      RaceCreatorState(
        status: const CubitStatusLoading(),
        race: createRace(id: 'c1'),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      ),
      RaceCreatorState(
        status: const CubitStatusComplete<RaceCreatorCubitInfo>(
          info: RaceCreatorCubitInfo.raceUpdated,
        ),
        race: createRace(id: 'c1'),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      ),
    ],
    verify: (_) => verify(
      () => raceRepository.updateRace(
        raceId: 'c1',
        userId: 'u1',
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'race is not null, '
    'duration is 0, '
    'should call method from race repository to update race with duration set as null and '
    'should emit info that race has been updated',
    build: () => createCubit(
      race: createRace(id: 'c1'),
      name: 'race name',
      date: DateTime(2023, 6, 2),
      place: 'New York',
      distance: 21,
      expectedDuration: const Duration(),
    ),
    setUp: () => raceRepository.mockUpdateRace(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      RaceCreatorState(
        status: const CubitStatusLoading(),
        race: createRace(id: 'c1'),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(),
      ),
      RaceCreatorState(
        status: const CubitStatusComplete<RaceCreatorCubitInfo>(
          info: RaceCreatorCubitInfo.raceUpdated,
        ),
        race: createRace(id: 'c1'),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(),
      ),
    ],
    verify: (_) => verify(
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
    ).called(1),
  );

  blocTest(
    'submit, '
    'race is not null, '
    'race repository method to update race throws entity exception with '
    'entityNotFound code, '
    'should emit error status with raceNoLongerExists error',
    build: () => createCubit(
      race: createRace(id: 'c1'),
      name: 'race name',
      date: DateTime(2023, 6, 2),
      place: 'New York',
      distance: 21,
      expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
    ),
    setUp: () => raceRepository.mockUpdateRace(
      throwable: const EntityException(
        code: EntityExceptionCode.entityNotFound,
      ),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      RaceCreatorState(
        status: const CubitStatusLoading(),
        race: createRace(id: 'c1'),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      ),
      RaceCreatorState(
        status: const CubitStatusError<RaceCreatorCubitError>(
          error: RaceCreatorCubitError.raceNoLongerExists,
        ),
        race: createRace(id: 'c1'),
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      ),
    ],
    verify: (_) => verify(
      () => raceRepository.updateRace(
        raceId: 'c1',
        userId: 'u1',
        name: 'race name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      ),
    ).called(1),
  );
}
