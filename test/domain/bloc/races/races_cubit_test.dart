import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/bloc/races/races_cubit.dart';

import '../../../creators/race_creator.dart';
import '../../../mock/domain/repository/mock_race_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final raceRepository = MockRaceRepository();
  const String loggedUserId = 'u1';

  RacesCubit createCubit() => RacesCubit(
        authService: authService,
        raceRepository: raceRepository,
      );

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.initialize(),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'should set listener of races belonging to logged user, should sort races by descending by date and emit them',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      raceRepository.mockGetAllRaces(
        races: [
          createRace(
            id: 'c1',
            userId: loggedUserId,
            date: DateTime(2023, 6, 10),
          ),
          createRace(
            id: 'c2',
            userId: loggedUserId,
            date: DateTime(2023, 4, 20),
          ),
          createRace(
            id: 'c3',
            userId: loggedUserId,
            date: DateTime(2023, 5, 30),
          ),
        ],
      );
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [
      [
        createRace(
          id: 'c1',
          userId: loggedUserId,
          date: DateTime(2023, 6, 10),
        ),
        createRace(
          id: 'c3',
          userId: loggedUserId,
          date: DateTime(2023, 5, 30),
        ),
        createRace(
          id: 'c2',
          userId: loggedUserId,
          date: DateTime(2023, 4, 20),
        ),
      ],
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => raceRepository.getAllRaces(userId: loggedUserId),
      ).called(1);
    },
  );
}
