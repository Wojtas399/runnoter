import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/bloc/competitions/competitions_cubit.dart';

import '../../../creators/competition_creator.dart';
import '../../../mock/domain/repository/mock_competition_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final competitionRepository = MockCompetitionRepository();

  CompetitionsCubit createCubit() => CompetitionsCubit(
        authService: authService,
        competitionRepository: competitionRepository,
      );

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (CompetitionsCubit cubit) => cubit.initialize(),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'should set listener of competitions belonging to logged user',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      competitionRepository.mockGetAllCompetitions(
        competitions: [
          createCompetition(id: 'c1', userId: 'u1'),
          createCompetition(id: 'c2', userId: 'u1'),
          createCompetition(id: 'c3', userId: 'u1'),
        ],
      );
    },
    act: (CompetitionsCubit cubit) => cubit.initialize(),
    expect: () => [
      [
        createCompetition(id: 'c1', userId: 'u1'),
        createCompetition(id: 'c2', userId: 'u1'),
        createCompetition(id: 'c3', userId: 'u1'),
      ],
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => competitionRepository.getAllCompetitions(
          userId: 'u1',
        ),
      ).called(1);
    },
  );
}
