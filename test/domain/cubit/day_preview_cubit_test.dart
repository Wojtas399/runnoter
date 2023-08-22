import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/domain/cubit/day_preview_cubit.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';
import 'package:runnoter/domain/entity/race.dart';
import 'package:runnoter/domain/entity/workout.dart';
import 'package:runnoter/domain/repository/health_measurement_repository.dart';
import 'package:runnoter/domain/repository/race_repository.dart';
import 'package:runnoter/domain/repository/workout_repository.dart';

import '../../creators/health_measurement_creator.dart';
import '../../creators/race_creator.dart';
import '../../creators/workout_creator.dart';
import '../../mock/common/mock_date_service.dart';
import '../../mock/domain/repository/mock_health_measurement_repository.dart';
import '../../mock/domain/repository/mock_race_repository.dart';
import '../../mock/domain/repository/mock_workout_repository.dart';

void main() {
  final healthMeasurementRepository = MockHealthMeasurementRepository();
  final workoutRepository = MockWorkoutRepository();
  final raceRepository = MockRaceRepository();
  final dateService = MockDateService();
  final DateTime date = DateTime(2023, 4, 10);
  const String userId = 'u1';

  DayPreviewCubit createCubit({DayPreviewState? state}) =>
      DayPreviewCubit(userId: userId, date: date, state: state);

  setUpAll(() {
    GetIt.I.registerFactory<DateService>(() => dateService);
    GetIt.I.registerSingleton<HealthMeasurementRepository>(
      healthMeasurementRepository,
    );
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
  });

  tearDown(() {
    reset(healthMeasurementRepository);
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

  group(
    'initialize',
    () {
      final HealthMeasurement healthMeasurement =
          createHealthMeasurement(date: date);
      final List<Workout> workouts = [
        createWorkout(id: 'w1'),
        createWorkout(id: 'w2'),
      ];
      final List<Race> races = [createRace(id: 'r1'), createRace(id: 'r2')];
      final StreamController<HealthMeasurement?> healthMeasurement$ =
          StreamController()..add(healthMeasurement);
      final StreamController<List<Workout>?> workouts$ = StreamController()
        ..add(workouts);
      final StreamController<List<Race>?> races$ = StreamController()
        ..add(races);

      blocTest(
        'should set listener of health measurement, workouts and races from given date',
        build: () => createCubit(),
        setUp: () {
          healthMeasurementRepository.mockGetMeasurementByDate(
            measurementStream: healthMeasurement$.stream,
          );
          workoutRepository.mockGetWorkoutsByDate(
            workoutsStream: workouts$.stream,
          );
          raceRepository.mockGetRacesByDate(racesStream: races$.stream);
        },
        act: (cubit) async {
          cubit.initialize();
          healthMeasurement$.add(null);
          workouts$.add([]);
          races$.add([]);
        },
        expect: () => [
          DayPreviewState(
            healthMeasurement: healthMeasurement,
            workouts: workouts,
            races: races,
          ),
          DayPreviewState(
            healthMeasurement: null,
            workouts: workouts,
            races: races,
          ),
          DayPreviewState(
            healthMeasurement: null,
            workouts: const [],
            races: races,
          ),
          const DayPreviewState(
            healthMeasurement: null,
            workouts: [],
            races: [],
          ),
        ],
        verify: (_) {
          verify(
            () => healthMeasurementRepository.getMeasurementByDate(
              date: date,
              userId: userId,
            ),
          ).called(1);
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
