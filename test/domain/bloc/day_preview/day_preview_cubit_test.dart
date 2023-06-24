import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/bloc/day_preview/day_preview_cubit.dart';
import 'package:runnoter/domain/entity/competition.dart';
import 'package:runnoter/domain/entity/workout.dart';

import '../../../creators/competition_creator.dart';
import '../../../creators/workout_creator.dart';
import '../../../mock/common/mock_date_service.dart';
import '../../../mock/domain/repository/mock_competition_repository.dart';
import '../../../mock/domain/repository/mock_workout_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();
  final competitionRepository = MockCompetitionRepository();
  final dateService = MockDateService();
  final DateTime date = DateTime(2023, 4, 10);
  const String loggedUserId = 'u1';

  DayPreviewCubit createCubit({
    List<Workout>? workouts,
    List<Competition>? competitions,
  }) =>
      DayPreviewCubit(
        date: date,
        authService: authService,
        workoutRepository: workoutRepository,
        competitionRepository: competitionRepository,
        dateService: dateService,
        state: DayPreviewState(
          workouts: workouts,
          competitions: competitions,
        ),
      );

  tearDown(() {
    reset(authService);
    reset(workoutRepository);
    reset(competitionRepository);
    reset(dateService);
  });

  blocTest(
    'is past date, '
    'date is from the past, '
    'should return true',
    build: () => createCubit(),
    setUp: () {
      dateService.mockGetToday(
        todayDate: date.add(
          const Duration(days: 2),
        ),
      );
    },
    verify: (DayPreviewCubit cubit) {
      expect(cubit.isPastDate, true);
    },
  );

  blocTest(
    'is past date, '
    'date is from now, '
    'should return false',
    build: () => createCubit(),
    setUp: () {
      dateService.mockGetToday(
        todayDate: date,
      );
    },
    verify: (DayPreviewCubit cubit) {
      expect(cubit.isPastDate, false);
    },
  );

  blocTest(
    'is past date, '
    'date is from the future, '
    'should return false',
    build: () => createCubit(),
    setUp: () {
      dateService.mockGetToday(
        todayDate: date.subtract(
          const Duration(days: 2),
        ),
      );
    },
    verify: (DayPreviewCubit cubit) {
      expect(cubit.isPastDate, false);
    },
  );

  blocTest(
    'are there activities, '
    'list of workouts is not null and not empty, '
    'should be true',
    build: () => createCubit(
      workouts: [
        createWorkout(id: 'w1'),
      ],
    ),
    verify: (DayPreviewCubit cubit) {
      expect(cubit.areThereActivities, true);
    },
  );

  blocTest(
    'are there activities, '
    'list of competitions is not null and not empty, '
    'should be true',
    build: () => createCubit(
      competitions: [
        createCompetition(id: 'c®1'),
      ],
    ),
    verify: (DayPreviewCubit cubit) {
      expect(cubit.areThereActivities, true);
    },
  );

  blocTest(
    'are there activities, '
    'list of workouts is empty, '
    'should be false',
    build: () => createCubit(
      workouts: [],
    ),
    verify: (DayPreviewCubit cubit) {
      expect(cubit.areThereActivities, false);
    },
  );

  blocTest(
    'are there activities, '
    'list of competitions is empty, '
    'should be false',
    build: () => createCubit(
      competitions: [],
    ),
    verify: (DayPreviewCubit cubit) {
      expect(cubit.areThereActivities, false);
    },
  );

  blocTest(
    'are there activities, '
    'list of workouts and list of competitions are null, '
    'should be false',
    build: () => createCubit(),
    verify: (DayPreviewCubit cubit) {
      expect(cubit.areThereActivities, false);
    },
  );

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
