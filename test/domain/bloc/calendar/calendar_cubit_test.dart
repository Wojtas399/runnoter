import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/bloc/calendar/calendar_cubit.dart';

import '../../../creators/race_creator.dart';
import '../../../creators/workout_creator.dart';
import '../../../mock/domain/repository/mock_race_repository.dart';
import '../../../mock/domain/repository/mock_workout_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();
  final raceRepository = MockRaceRepository();

  CalendarCubit createCubit() => CalendarCubit(
        authService: authService,
        workoutRepository: workoutRepository,
        raceRepository: raceRepository,
      );

  tearDown(() {
    reset(authService);
    reset(workoutRepository);
    reset(raceRepository);
  });

  blocTest(
    'month changed, '
    'should set new listener of workouts and races from new month',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockGetWorkoutsByDateRange(
        workouts: [
          createWorkout(id: 'w1', name: 'workout 1'),
          createWorkout(id: 'w2', name: 'workout 2'),
        ],
      );
      raceRepository.mockGetRacesByDateRange(
        races: [
          createRace(id: 'c1', name: 'race 1'),
          createRace(id: 'c2', name: 'race 2'),
        ],
      );
    },
    act: (CalendarCubit cubit) => cubit.monthChanged(
      firstDisplayingDate: DateTime(2023, 1, 1),
      lastDisplayingDate: DateTime(2023, 1, 31),
    ),
    expect: () => [
      CalendarState(
        workouts: [
          createWorkout(id: 'w1', name: 'workout 1'),
          createWorkout(id: 'w2', name: 'workout 2'),
        ],
        races: [
          createRace(id: 'c1', name: 'race 1'),
          createRace(id: 'c2', name: 'race 2'),
        ],
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getWorkoutsByDateRange(
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 1, 31),
          userId: 'u1',
        ),
      ).called(1);
    },
  );
}
