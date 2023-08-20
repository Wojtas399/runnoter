import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/domain/additional_model/activities.dart';
import 'package:runnoter/domain/cubit/day_preview_cubit.dart';
import 'package:runnoter/domain/entity/race.dart';
import 'package:runnoter/domain/entity/workout.dart';
import 'package:runnoter/domain/repository/race_repository.dart';
import 'package:runnoter/domain/repository/workout_repository.dart';

import '../../creators/race_creator.dart';
import '../../creators/workout_creator.dart';
import '../../mock/common/mock_date_service.dart';
import '../../mock/domain/repository/mock_race_repository.dart';
import '../../mock/domain/repository/mock_workout_repository.dart';

void main() {
  final workoutRepository = MockWorkoutRepository();
  final raceRepository = MockRaceRepository();
  final dateService = MockDateService();
  final DateTime date = DateTime(2023, 4, 10);
  const String userId = 'u1';

  DayPreviewCubit createCubit({
    List<Workout>? workouts,
    List<Race>? races,
  }) =>
      DayPreviewCubit(
        userId: userId,
        date: date,
        activities: Activities(workouts: workouts, races: races),
      );

  setUpAll(() {
    GetIt.I.registerFactory<DateService>(() => dateService);
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
  });

  tearDown(() {
    reset(workoutRepository);
    reset(raceRepository);
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
    'list of races is not null and not empty, '
    'should be true',
    build: () => createCubit(
      races: [
        createRace(id: 'c®1'),
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
    'list of races is empty, '
    'should be false',
    build: () => createCubit(
      races: [],
    ),
    verify: (DayPreviewCubit cubit) {
      expect(cubit.areThereActivities, false);
    },
  );

  blocTest(
    'are there activities, '
    'list of workouts and list of races are null, '
    'should be false',
    build: () => createCubit(),
    verify: (DayPreviewCubit cubit) {
      expect(cubit.areThereActivities, false);
    },
  );

  group(
    'initialize',
    () {
      final List<Workout> workouts = [
        createWorkout(id: 'w1'),
        createWorkout(id: 'w2'),
      ];
      final List<Race> races = [createRace(id: 'r1'), createRace(id: 'r2')];
      final StreamController<List<Workout>?> workouts$ = StreamController()
        ..add(workouts);
      final StreamController<List<Race>?> races$ = StreamController()
        ..add(races);

      blocTest(
        'should set listener of workouts and races from given date belonging to user',
        build: () => createCubit(),
        setUp: () {
          workoutRepository.mockGetWorkoutsByDate(
            workoutsStream: workouts$.stream,
          );
          raceRepository.mockGetRacesByDate(racesStream: races$.stream);
        },
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          workouts$.add([]);
          await cubit.stream.first;
          races$.add([]);
        },
        expect: () => [
          Activities(workouts: workouts, races: races),
          Activities(workouts: const [], races: races),
          const Activities(workouts: [], races: []),
        ],
        verify: (_) {
          verify(
            () => workoutRepository.getWorkoutsByDate(
              date: date,
              userId: userId,
            ),
          ).called(1);
          verify(
            () => raceRepository.getRacesByDate(
              date: date,
              userId: userId,
            ),
          ).called(1);
        },
      );
    },
  );
}
