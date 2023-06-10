import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/competition_creator/competition_creator_bloc.dart';
import 'package:runnoter/domain/entity/competition.dart';
import 'package:runnoter/domain/entity/run_status.dart';

import '../../../creators/competition_creator.dart';
import '../../../mock/domain/repository/mock_competition_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final competitionRepository = MockCompetitionRepository();
  const String userId = 'u1';

  CompetitionCreatorBloc createBloc({
    Competition? competition,
    String? name,
    DateTime? date,
    String? place,
    double? distance,
    Duration? expectedDuration,
  }) =>
      CompetitionCreatorBloc(
        authService: authService,
        competitionRepository: competitionRepository,
        state: CompetitionCreatorState(
          status: const BlocStatusInitial(),
          competition: competition,
          name: name,
          date: date,
          place: place,
          distance: distance,
          expectedDuration: expectedDuration,
        ),
      );

  CompetitionCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    Competition? competition,
    String? name,
    DateTime? date,
    String? place,
    double? distance,
    Duration? expectedDuration,
  }) =>
      CompetitionCreatorState(
        status: status,
        competition: competition,
        name: name,
        date: date,
        place: place,
        distance: distance,
        expectedDuration: expectedDuration,
      );

  tearDown(() {
    reset(authService);
    reset(competitionRepository);
  });

  blocTest(
    'initialize, '
    'competition id is null, '
    'should do nothing',
    build: () => createBloc(),
    act: (CompetitionCreatorBloc bloc) => bloc.add(
      const CompetitionCreatorEventInitialize(competitionId: null),
    ),
    expect: () => [],
  );

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (CompetitionCreatorBloc bloc) => bloc.add(
      const CompetitionCreatorEventInitialize(competitionId: 'c1'),
    ),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'should load competition matching to given id from repository and should update all relevant params in state',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: userId,
      );
      competitionRepository.mockGetCompetitionById(
        competition: createCompetition(
          id: 'c1',
          userId: userId,
          name: 'name',
          date: DateTime(2023, 6, 10),
          place: 'place',
          distance: 21,
          expectedDuration: const Duration(hours: 2),
        ),
      );
    },
    act: (CompetitionCreatorBloc bloc) => bloc.add(
      const CompetitionCreatorEventInitialize(competitionId: 'c1'),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete<CompetitionCreatorBlocInfo>(
          info: CompetitionCreatorBlocInfo.editModeInitialized,
        ),
        competition: createCompetition(
          id: 'c1',
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
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => competitionRepository.getCompetitionById(
          competitionId: 'c1',
          userId: userId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'name changed, '
    'should update name in state',
    build: () => createBloc(),
    act: (CompetitionCreatorBloc bloc) => bloc.add(
      const CompetitionCreatorEventNameChanged(
        name: 'competition name',
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        name: 'competition name',
      ),
    ],
  );

  blocTest(
    'date changed, '
    'should update date in state',
    build: () => createBloc(),
    act: (CompetitionCreatorBloc bloc) => bloc.add(
      CompetitionCreatorEventDateChanged(
        date: DateTime(2023, 6, 2),
      ),
    ),
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
    act: (CompetitionCreatorBloc bloc) => bloc.add(
      const CompetitionCreatorEventPlaceChanged(
        place: 'competition place',
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        place: 'competition place',
      ),
    ],
  );

  blocTest(
    'distance changed, '
    'should update distance in state',
    build: () => createBloc(),
    act: (CompetitionCreatorBloc bloc) => bloc.add(
      const CompetitionCreatorEventDistanceChanged(
        distance: 21,
      ),
    ),
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
    act: (CompetitionCreatorBloc bloc) => bloc.add(
      const CompetitionCreatorEventExpectedDurationChanged(
        expectedDuration: Duration(hours: 1, minutes: 45, seconds: 20),
      ),
    ),
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
    act: (CompetitionCreatorBloc bloc) => bloc.add(
      const CompetitionCreatorEventSubmit(),
    ),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'competition params are same as original, '
    'should do nothing',
    build: () => createBloc(
      competition: createCompetition(
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
    act: (CompetitionCreatorBloc bloc) => bloc.add(
      const CompetitionCreatorEventSubmit(),
    ),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'logged user does not exist, '
    'should emit no logged user bloc status',
    build: () => createBloc(
      name: 'competition name',
      date: DateTime(2023, 6, 2),
      place: 'New York',
      distance: 21,
      expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (CompetitionCreatorBloc bloc) => bloc.add(
      const CompetitionCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
        name: 'competition name',
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
    'should call method from competition repository to add new competition with pending status and should emit info that competition has been added',
    build: () => createBloc(
      name: 'competition name',
      date: DateTime(2023, 6, 2),
      place: 'New York',
      distance: 21,
      expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      competitionRepository.mockAddNewCompetition();
    },
    act: (CompetitionCreatorBloc bloc) => bloc.add(
      const CompetitionCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        name: 'competition name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      ),
      createState(
        status: const BlocStatusComplete<CompetitionCreatorBlocInfo>(
          info: CompetitionCreatorBlocInfo.competitionAdded,
        ),
        name: 'competition name',
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
        () => competitionRepository.addNewCompetition(
          userId: 'u1',
          name: 'competition name',
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
    'should call method from competition repository to add new competition with duration set as null and pending status and should emit info that competition has been added',
    build: () => createBloc(
      name: 'competition name',
      date: DateTime(2023, 6, 2),
      place: 'New York',
      distance: 21,
      expectedDuration: const Duration(),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      competitionRepository.mockAddNewCompetition();
    },
    act: (CompetitionCreatorBloc bloc) => bloc.add(
      const CompetitionCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        name: 'competition name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(),
      ),
      createState(
        status: const BlocStatusComplete<CompetitionCreatorBlocInfo>(
          info: CompetitionCreatorBlocInfo.competitionAdded,
        ),
        name: 'competition name',
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
        () => competitionRepository.addNewCompetition(
          userId: 'u1',
          name: 'competition name',
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
    'should call method from competition repository to update competition and should emit info that competition has been updated',
    build: () => createBloc(
      competition: createCompetition(id: 'c1'),
      name: 'competition name',
      date: DateTime(2023, 6, 2),
      place: 'New York',
      distance: 21,
      expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      competitionRepository.mockUpdateCompetition();
    },
    act: (CompetitionCreatorBloc bloc) => bloc.add(
      const CompetitionCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        competition: createCompetition(id: 'c1'),
        name: 'competition name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(hours: 1, minutes: 45, seconds: 20),
      ),
      createState(
        status: const BlocStatusComplete<CompetitionCreatorBlocInfo>(
          info: CompetitionCreatorBlocInfo.competitionUpdated,
        ),
        competition: createCompetition(id: 'c1'),
        name: 'competition name',
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
        () => competitionRepository.updateCompetition(
          competitionId: 'c1',
          userId: 'u1',
          name: 'competition name',
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
    'should call method from competition repository to update competition with duration set as null and should emit info that competition has been updated',
    build: () => createBloc(
      competition: createCompetition(id: 'c1'),
      name: 'competition name',
      date: DateTime(2023, 6, 2),
      place: 'New York',
      distance: 21,
      expectedDuration: const Duration(),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      competitionRepository.mockUpdateCompetition();
    },
    act: (CompetitionCreatorBloc bloc) => bloc.add(
      const CompetitionCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        competition: createCompetition(id: 'c1'),
        name: 'competition name',
        date: DateTime(2023, 6, 2),
        place: 'New York',
        distance: 21,
        expectedDuration: const Duration(),
      ),
      createState(
        status: const BlocStatusComplete<CompetitionCreatorBlocInfo>(
          info: CompetitionCreatorBlocInfo.competitionUpdated,
        ),
        competition: createCompetition(id: 'c1'),
        name: 'competition name',
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
        () => competitionRepository.updateCompetition(
          competitionId: 'c1',
          userId: 'u1',
          name: 'competition name',
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
