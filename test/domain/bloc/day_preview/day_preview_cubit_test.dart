import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/bloc/day_preview/day_preview_cubit.dart';

import '../../../creators/competition_creator.dart';
import '../../../creators/workout_creator.dart';
import '../../../mock/domain/repository/mock_competition_repository.dart';
import '../../../mock/domain/repository/mock_workout_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();
  final competitionRepository = MockCompetitionRepository();
  final DateTime date = DateTime(2023, 4, 10);
  const String loggedUserId = 'u1';

  DayPreviewCubit createCubit() => DayPreviewCubit(
        date: date,
        authService: authService,
        workoutRepository: workoutRepository,
        competitionRepository: competitionRepository,
      );

  tearDown(() {
    reset(authService);
    reset(workoutRepository);
    reset(competitionRepository);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (DayPreviewCubit cubit) => cubit.initialize(),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'should set listener of workouts and competitions from given date belonging to logged user',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockGetWorkoutsByDate(
        workouts: [
          createWorkout(id: 'w1', userId: loggedUserId),
          createWorkout(id: 'w2', userId: loggedUserId),
        ],
      );
      competitionRepository.mockGetCompetitionsByDate(
        competitions: [
          createCompetition(id: 'c1', userId: loggedUserId),
        ],
      );
    },
    act: (DayPreviewCubit cubit) => cubit.initialize(),
    expect: () => [
      DayPreviewState(
        workouts: [
          createWorkout(id: 'w1', userId: loggedUserId),
          createWorkout(id: 'w2', userId: loggedUserId),
        ],
        competitions: [
          createCompetition(id: 'c1', userId: loggedUserId),
        ],
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getWorkoutsByDate(
          date: date,
          userId: loggedUserId,
        ),
      ).called(1);
      verify(
        () => competitionRepository.getCompetitionsByDate(
          date: date,
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );
}
