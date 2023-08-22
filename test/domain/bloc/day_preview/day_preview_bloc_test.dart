import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/day_preview/day_preview_bloc.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';
import 'package:runnoter/domain/entity/race.dart';
import 'package:runnoter/domain/entity/workout.dart';
import 'package:runnoter/domain/repository/health_measurement_repository.dart';
import 'package:runnoter/domain/repository/race_repository.dart';
import 'package:runnoter/domain/repository/workout_repository.dart';

import '../../../creators/health_measurement_creator.dart';
import '../../../creators/race_creator.dart';
import '../../../creators/workout_creator.dart';
import '../../../mock/common/mock_date_service.dart';
import '../../../mock/domain/repository/mock_health_measurement_repository.dart';
import '../../../mock/domain/repository/mock_race_repository.dart';
import '../../../mock/domain/repository/mock_workout_repository.dart';

void main() {
  final healthMeasurementRepository = MockHealthMeasurementRepository();
  final workoutRepository = MockWorkoutRepository();
  final raceRepository = MockRaceRepository();
  final dateService = MockDateService();
  const String userId = 'u1';
  final DateTime date = DateTime(2023, 2, 2);

  DayPreviewBloc createBloc({
    DayPreviewState state = const DayPreviewState(status: BlocStatusInitial()),
  }) =>
      DayPreviewBloc(userId: userId, date: date, state: state);

  setUpAll(() {
    GetIt.I.registerSingleton<HealthMeasurementRepository>(
      healthMeasurementRepository,
    );
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
    GetIt.I.registerFactory<DateService>(() => dateService);
  });

  tearDown(() {
    reset(healthMeasurementRepository);
    reset(workoutRepository);
    reset(raceRepository);
    reset(dateService);
  });

  group(
    'initialize listener',
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
        'date is from the past, '
        'should set isPastDay as true and '
        'should set listener of health measurement, workouts and races from given date',
        build: () => createBloc(),
        setUp: () {
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
          bloc.add(const DayPreviewEventInitialize());
          healthMeasurement$.add(null);
          workouts$.add([]);
          races$.add([]);
        },
        expect: () => [
          DayPreviewState(
            status: const BlocStatusComplete(),
            isPastDay: true,
            healthMeasurement: healthMeasurement,
            workouts: workouts,
            races: races,
          ),
          DayPreviewState(
            status: const BlocStatusComplete(),
            isPastDay: true,
            healthMeasurement: null,
            workouts: workouts,
            races: races,
          ),
          DayPreviewState(
            status: const BlocStatusComplete(),
            isPastDay: true,
            healthMeasurement: null,
            workouts: const [],
            races: races,
          ),
          const DayPreviewState(
            status: BlocStatusComplete(),
            isPastDay: true,
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

      blocTest(
        'date is not from the past, '
        'should set isPastDay as false and '
        'should set listener of health measurement, workouts and races from given date',
        build: () => createBloc(),
        setUp: () {
          dateService.mockGetToday(todayDate: date);
          healthMeasurementRepository.mockGetMeasurementByDate(
            measurement: healthMeasurement,
          );
          workoutRepository.mockGetWorkoutsByDate(workouts: workouts);
          raceRepository.mockGetRacesByDate(races: races);
        },
        act: (bloc) => bloc.add(const DayPreviewEventInitialize()),
        expect: () => [
          DayPreviewState(
            status: const BlocStatusComplete(),
            isPastDay: false,
            healthMeasurement: healthMeasurement,
            workouts: workouts,
            races: races,
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

  blocTest(
    'remove health measurement, '
    'health measurement is null, '
    'should do nothing',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const DayPreviewEventRemoveHealthMeasurement()),
    expect: () => [],
  );

  blocTest(
    'remove health measurement, '
    "should call health measurement repository's method to delete measurement and "
    'should emit DayPreviewBlocInfo.healthMeasurementDeleted',
    build: () => createBloc(
      state: DayPreviewState(
        status: const BlocStatusInitial(),
        healthMeasurement: createHealthMeasurement(date: date),
      ),
    ),
    setUp: () => healthMeasurementRepository.mockDeleteMeasurement(),
    act: (bloc) => bloc.add(const DayPreviewEventRemoveHealthMeasurement()),
    expect: () => [
      DayPreviewState(
        status: const BlocStatusLoading(),
        healthMeasurement: createHealthMeasurement(date: date),
      ),
      DayPreviewState(
        status: const BlocStatusComplete<DayPreviewBlocInfo>(
          info: DayPreviewBlocInfo.healthMeasurementDeleted,
        ),
        healthMeasurement: createHealthMeasurement(date: date),
      ),
    ],
    verify: (_) => verify(
      () => healthMeasurementRepository.deleteMeasurement(
        userId: userId,
        date: date,
      ),
    ).called(1),
  );
}
