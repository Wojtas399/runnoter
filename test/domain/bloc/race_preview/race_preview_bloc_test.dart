import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/race_preview/race_preview_bloc.dart';
import 'package:runnoter/domain/entity/race.dart';

import '../../../creators/race_creator.dart';
import '../../../mock/domain/repository/mock_race_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final raceRepository = MockRaceRepository();

  RacePreviewBloc createBloc({
    Race? race,
  }) =>
      RacePreviewBloc(
        authService: authService,
        raceRepository: raceRepository,
        state: RacePreviewState(
          status: const BlocStatusInitial(),
          race: race,
        ),
      );

  RacePreviewState createState({
    BlocStatus status = const BlocStatusInitial(),
    Race? race,
  }) =>
      RacePreviewState(
        status: status,
        race: race,
      );

  tearDown(() {
    reset(authService);
    reset(raceRepository);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (RacePreviewBloc bloc) => bloc.add(
      const RacePreviewEventInitialize(raceId: 'c1'),
    ),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'should set listener of race matching to given id',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: 'u1',
      );
      raceRepository.mockGetRaceById(
        race: createRace(
          id: 'c1',
          userId: 'u1',
          name: 'race 1',
        ),
      );
    },
    act: (RacePreviewBloc bloc) => bloc.add(
      const RacePreviewEventInitialize(raceId: 'c1'),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        race: createRace(
          id: 'c1',
          userId: 'u1',
          name: 'race 1',
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => raceRepository.getRaceById(
          raceId: 'c1',
          userId: 'u1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'race updated, '
    'should update race in state',
    build: () => createBloc(),
    act: (RacePreviewBloc bloc) => bloc.add(
      RacePreviewEventRaceUpdated(
        race: createRace(
          id: 'c1',
          userId: 'u1',
          name: 'race 1',
        ),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        race: createRace(
          id: 'c1',
          userId: 'u1',
          name: 'race 1',
        ),
      ),
    ],
  );

  blocTest(
    'delete race, '
    'race is null, '
    'should do nothing',
    build: () => createBloc(),
    act: (RacePreviewBloc bloc) => bloc.add(
      const RacePreviewEventDeleteRace(),
    ),
    expect: () => [],
  );

  blocTest(
    'delete race, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => createBloc(
      race: createRace(id: 'c1'),
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (RacePreviewBloc bloc) => bloc.add(
      const RacePreviewEventDeleteRace(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
        race: createRace(id: 'c1'),
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'delete race, '
    'should call method from race repository to delete race and should emit info that race has been deleted',
    build: () => createBloc(
      race: createRace(id: 'c1'),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      raceRepository.mockDeleteRace();
    },
    act: (RacePreviewBloc bloc) => bloc.add(
      const RacePreviewEventDeleteRace(),
    ),
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
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => raceRepository.deleteRace(
          raceId: 'c1',
          userId: 'u1',
        ),
      ).called(1);
    },
  );
}
