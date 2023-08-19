import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/cubit/client_calendar_cubit.dart';
import 'package:runnoter/domain/entity/race.dart';
import 'package:runnoter/domain/entity/workout.dart';
import 'package:runnoter/domain/repository/race_repository.dart';
import 'package:runnoter/domain/repository/workout_repository.dart';

import '../../creators/race_creator.dart';
import '../../creators/workout_creator.dart';
import '../../mock/domain/repository/mock_race_repository.dart';
import '../../mock/domain/repository/mock_workout_repository.dart';

void main() {
  final workoutRepository = MockWorkoutRepository();
  final raceRepository = MockRaceRepository();
  const String clientId = 'c1';

  setUpAll(() {
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
  });

  tearDown(() {
    reset(workoutRepository);
    reset(raceRepository);
  });

  group(
    'date range changed',
    () {
      final List<Workout> workouts = [
        createWorkout(id: 'w1', name: 'first workout'),
        createWorkout(id: 'w2', name: 'second workout'),
      ];
      final List<Race> races = [
        createRace(id: 'r1', name: 'first race'),
        createRace(id: 'r2', name: 'second race'),
      ];
      final List<Workout> updatedWorkouts = [
        createWorkout(id: 'w1', name: 'updated first workout'),
        createWorkout(id: 'w2', name: 'updated second workout'),
      ];
      final List<Race> updatedRaces = [
        createRace(id: 'r1', name: 'updated first race'),
        createRace(id: 'r2', name: 'updated second race'),
      ];
      final StreamController<List<Workout>> workouts$ = StreamController()
        ..add(workouts);
      final StreamController<List<Race>> races$ = StreamController()
        ..add(races);
      final DateTime startDate = DateTime(2023, 2);
      final DateTime endDate = DateTime(2023, 3);

      blocTest(
        'should set listener of workouts and races from date range',
        build: () => ClientCalendarCubit(clientId: clientId),
        setUp: () {
          workoutRepository.mockGetWorkoutsByDateRange(
            workoutsStream: workouts$.stream,
          );
          raceRepository.mockGetRacesByDateRange(racesStream: races$.stream);
        },
        act: (cubit) async {
          cubit.dateRangeChanged(startDate: startDate, endDate: endDate);
          await cubit.stream.first;
          workouts$.add(updatedWorkouts);
          races$.add(updatedRaces);
        },
        expect: () => [
          ClientCalendarState(workouts: workouts, races: races),
          ClientCalendarState(workouts: updatedWorkouts, races: races),
          ClientCalendarState(workouts: updatedWorkouts, races: updatedRaces),
        ],
        verify: (_) {
          verify(
            () => workoutRepository.getWorkoutsByDateRange(
              startDate: startDate,
              endDate: endDate,
              userId: clientId,
            ),
          ).called(1);
          verify(
            () => raceRepository.getRacesByDateRange(
              startDate: startDate,
              endDate: endDate,
              userId: clientId,
            ),
          ).called(1);
        },
      );
    },
  );
}
