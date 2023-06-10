import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/competition_preview/competition_preview_bloc.dart';
import 'package:runnoter/domain/entity/competition.dart';

import '../../../creators/competition_creator.dart';
import '../../../mock/domain/repository/mock_competition_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final competitionRepository = MockCompetitionRepository();

  CompetitionPreviewBloc createBloc({
    Competition? competition,
  }) =>
      CompetitionPreviewBloc(
        authService: authService,
        competitionRepository: competitionRepository,
        state: CompetitionPreviewState(
          status: const BlocStatusInitial(),
          competition: competition,
        ),
      );

  CompetitionPreviewState createState({
    BlocStatus status = const BlocStatusInitial(),
    Competition? competition,
  }) =>
      CompetitionPreviewState(
        status: status,
        competition: competition,
      );

  tearDown(() {
    reset(authService);
    reset(competitionRepository);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (CompetitionPreviewBloc bloc) => bloc.add(
      const CompetitionPreviewEventInitialize(competitionId: 'c1'),
    ),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'should set listener of competition matching to given id',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: 'u1',
      );
      competitionRepository.mockGetCompetitionById(
        competition: createCompetition(
          id: 'c1',
          userId: 'u1',
          name: 'competition 1',
        ),
      );
    },
    act: (CompetitionPreviewBloc bloc) => bloc.add(
      const CompetitionPreviewEventInitialize(competitionId: 'c1'),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        competition: createCompetition(
          id: 'c1',
          userId: 'u1',
          name: 'competition 1',
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => competitionRepository.getCompetitionById(
          competitionId: 'c1',
          userId: 'u1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'competition updated, '
    'should update competition in state',
    build: () => createBloc(),
    act: (CompetitionPreviewBloc bloc) => bloc.add(
      CompetitionPreviewEventCompetitionUpdated(
        competition: createCompetition(
          id: 'c1',
          userId: 'u1',
          name: 'competition 1',
        ),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        competition: createCompetition(
          id: 'c1',
          userId: 'u1',
          name: 'competition 1',
        ),
      ),
    ],
  );

  blocTest(
    'delete competition, '
    'competition is null, '
    'should do nothing',
    build: () => createBloc(),
    act: (CompetitionPreviewBloc bloc) => bloc.add(
      const CompetitionPreviewEventDeleteCompetition(),
    ),
    expect: () => [],
  );

  blocTest(
    'delete competition, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => createBloc(
      competition: createCompetition(id: 'c1'),
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (CompetitionPreviewBloc bloc) => bloc.add(
      const CompetitionPreviewEventDeleteCompetition(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
        competition: createCompetition(id: 'c1'),
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'delete competition, '
    'should call method from competition repository to delete competition and should emit info that competition has been deleted',
    build: () => createBloc(
      competition: createCompetition(id: 'c1'),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      competitionRepository.mockDeleteCompetition();
    },
    act: (CompetitionPreviewBloc bloc) => bloc.add(
      const CompetitionPreviewEventDeleteCompetition(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        competition: createCompetition(id: 'c1'),
      ),
      createState(
        status: const BlocStatusComplete<CompetitionPreviewBlocInfo>(
          info: CompetitionPreviewBlocInfo.competitionDeleted,
        ),
        competition: createCompetition(id: 'c1'),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => competitionRepository.deleteCompetition(
          competitionId: 'c1',
          userId: 'u1',
        ),
      ).called(1);
    },
  );
}
