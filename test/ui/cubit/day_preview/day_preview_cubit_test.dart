import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/data/interface/repository/workout_repository.dart';
import 'package:runnoter/data/interface/service/auth_service.dart';
import 'package:runnoter/data/model/health_measurement.dart';
import 'package:runnoter/data/model/race.dart';
import 'package:runnoter/data/model/workout.dart';
import 'package:runnoter/data/repository/health_measurement/health_measurement_repository.dart';
import 'package:runnoter/data/repository/race/race_repository.dart';
import 'package:runnoter/ui/cubit/day_preview/day_preview_cubit.dart';

import '../../../creators/health_measurement_creator.dart';
import '../../../creators/race_creator.dart';
import '../../../creators/workout_creator.dart';
import '../../../mock/common/mock_date_service.dart';
import '../../../mock/data/repository/mock_health_measurement_repository.dart';
import '../../../mock/data/repository/mock_race_repository.dart';
import '../../../mock/data/repository/mock_workout_repository.dart';
import '../../../mock/data/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final healthMeasurementRepository = MockHealthMeasurementRepository();
  final workoutRepository = MockWorkoutRepository();
  final raceRepository = MockRaceRepository();
  final dateService = MockDateService();
  const String userId = 'u1';
  final DateTime date = DateTime(2023, 2, 2);

  DayPreviewCubit createCubit({
    DayPreviewState initialState = const DayPreviewState(),
  }) =>
      DayPreviewCubit(userId: userId, date: date, initialState: initialState);

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<HealthMeasurementRepository>(
      healthMeasurementRepository,
    );
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
    GetIt.I.registerFactory<DateService>(() => dateService);
  });

  tearDown(() {
    reset(authService);
    reset(healthMeasurementRepository);
    reset(workoutRepository);
    reset(raceRepository);
    reset(dateService);
  });

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
        'logged user does not exist, '
        'should do nothing',
        build: () => createCubit(),
        setUp: () => authService.mockGetLoggedUserId(),
        act: (bloc) => bloc.initialize(),
        expect: () => [],
        verify: (_) => verify(() => authService.loggedUserId$).called(1),
      );

      blocTest(
        'date is from the past, '
        'user id is equal to logged user id, '
        'should set isPastDate as true and '
        'should set canModifyHealthMeasurement as true and '
        'should set listener of health measurement, workouts and races from given date',
        build: () => createCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: userId);
          dateService.mockGetToday(
            todayDate: date.add(const Duration(days: 2)),
          );
          healthMeasurementRepository.mockGetMeasurementByDate(
            measurementStream: healthMeasurement$.stream,
          );
          workoutRepository.mockGetWorkoutsByDate(
            workoutsStream: workouts$.stream,
          );
          raceRepository.mockGetRacesByDate(racesStream: races$.stream);
        },
        act: (bloc) async {
          bloc.initialize();
          healthMeasurement$.add(null);
          workouts$.add([]);
          races$.add([]);
        },
        expect: () => [
          DayPreviewState(
            isPastDate: true,
            canModifyHealthMeasurement: true,
            healthMeasurement: healthMeasurement,
            workouts: workouts,
            races: races,
          ),
          DayPreviewState(
            isPastDate: true,
            canModifyHealthMeasurement: true,
            healthMeasurement: null,
            workouts: workouts,
            races: races,
          ),
          DayPreviewState(
            isPastDate: true,
            canModifyHealthMeasurement: true,
            healthMeasurement: null,
            workouts: const [],
            races: races,
          ),
          const DayPreviewState(
            isPastDate: true,
            canModifyHealthMeasurement: true,
            healthMeasurement: null,
            workouts: [],
            races: [],
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
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

      blocTest(
        'date is not from the past, '
        'user id is not equal to logged user id, '
        'should set isPastDate as false and '
        'should set canModifyHealthMeasurement as false and '
        'should set listener of health measurement, workouts and races from given date',
        build: () => createCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: 'u2');
          dateService.mockGetToday(todayDate: date);
          healthMeasurementRepository.mockGetMeasurementByDate(
            measurement: healthMeasurement,
          );
          workoutRepository.mockGetWorkoutsByDate(workouts: workouts);
          raceRepository.mockGetRacesByDate(races: races);
        },
        act: (bloc) => bloc.initialize(),
        expect: () => [
          DayPreviewState(
            isPastDate: false,
            canModifyHealthMeasurement: false,
            healthMeasurement: healthMeasurement,
            workouts: workouts,
            races: races,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
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

  blocTest(
    'remove health measurement, '
    'health measurement is null, '
    'should do nothing',
    build: () => createCubit(),
    act: (bloc) => bloc.removeHealthMeasurement(),
    expect: () => [],
  );

  blocTest(
    'remove health measurement, '
    "should call health measurement repository's method to delete measurement",
    build: () => createCubit(
      initialState: DayPreviewState(
        healthMeasurement: createHealthMeasurement(date: date),
      ),
    ),
    setUp: () => healthMeasurementRepository.mockDeleteMeasurement(),
    act: (bloc) => bloc.removeHealthMeasurement(),
    expect: () => [],
    verify: (_) => verify(
      () => healthMeasurementRepository.deleteMeasurement(
        userId: userId,
        date: date,
      ),
    ).called(1),
  );
}
