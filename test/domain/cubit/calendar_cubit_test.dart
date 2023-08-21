import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/calendar_date_range_data.dart';
import 'package:runnoter/domain/cubit/calendar_cubit.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';
import 'package:runnoter/domain/entity/race.dart';
import 'package:runnoter/domain/entity/workout.dart';
import 'package:runnoter/domain/repository/health_measurement_repository.dart';
import 'package:runnoter/domain/repository/race_repository.dart';
import 'package:runnoter/domain/repository/workout_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../creators/health_measurement_creator.dart';
import '../../creators/race_creator.dart';
import '../../creators/workout_creator.dart';
import '../../mock/domain/repository/mock_health_measurement_repository.dart';
import '../../mock/domain/repository/mock_race_repository.dart';
import '../../mock/domain/repository/mock_workout_repository.dart';
import '../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final healthMeasurementRepository = MockHealthMeasurementRepository();
  final workoutRepository = MockWorkoutRepository();
  final raceRepository = MockRaceRepository();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<HealthMeasurementRepository>(
      healthMeasurementRepository,
    );
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
  });

  tearDown(() {
    reset(authService);
    reset(healthMeasurementRepository);
    reset(workoutRepository);
    reset(raceRepository);
  });

  group(
    'date range changed',
    () {
      final List<HealthMeasurement> healthMeasurements = [
        createHealthMeasurement(date: DateTime(2023, 2, 11)),
        createHealthMeasurement(date: DateTime(2023, 2, 22)),
      ];
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
      final StreamController<List<HealthMeasurement>> healthMeasurements$ =
          StreamController()..add(healthMeasurements);
      final StreamController<List<Workout>> workouts$ = StreamController()
        ..add(workouts);
      final StreamController<List<Race>> races$ = StreamController()
        ..add(races);
      final DateTime startDate = DateTime(2023, 2);
      final DateTime endDate = DateTime(2023, 3);

      blocTest(
        'should set listener of health measurements, workouts and races from date range',
        build: () => CalendarCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          healthMeasurementRepository.mockGetMeasurementsByDateRange(
            measurementsStream: healthMeasurements$.stream,
          );
          workoutRepository.mockGetWorkoutsByDateRange(
            workoutsStream: workouts$.stream,
          );
          raceRepository.mockGetRacesByDateRange(racesStream: races$.stream);
        },
        act: (cubit) async {
          cubit.dateRangeChanged(startDate: startDate, endDate: endDate);
          await cubit.stream.first;
          healthMeasurements$.add([]);
          workouts$.add(updatedWorkouts);
          races$.add(updatedRaces);
        },
        expect: () => [
          CalendarDateRangeData(
            healthMeasurements: healthMeasurements,
            workouts: workouts,
            races: races,
          ),
          CalendarDateRangeData(
            healthMeasurements: const [],
            workouts: workouts,
            races: races,
          ),
          CalendarDateRangeData(
            healthMeasurements: const [],
            workouts: updatedWorkouts,
            races: races,
          ),
          CalendarDateRangeData(
            healthMeasurements: const [],
            workouts: updatedWorkouts,
            races: updatedRaces,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => healthMeasurementRepository.getMeasurementsByDateRange(
              startDate: startDate,
              endDate: endDate,
              userId: loggedUserId,
            ),
          ).called(1);
          verify(
            () => workoutRepository.getWorkoutsByDateRange(
              startDate: startDate,
              endDate: endDate,
              userId: loggedUserId,
            ),
          ).called(1);
          verify(
            () => raceRepository.getRacesByDateRange(
              startDate: startDate,
              endDate: endDate,
              userId: loggedUserId,
            ),
          ).called(1);
        },
      );
    },
  );
}
