import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/additional_model/workout_stage.dart';
import 'package:runnoter/data/entity/activity.dart';
import 'package:runnoter/data/entity/health_measurement.dart';
import 'package:runnoter/data/entity/race.dart';
import 'package:runnoter/data/entity/workout.dart';
import 'package:runnoter/data/interface/repository/health_measurement_repository.dart';
import 'package:runnoter/data/interface/repository/race_repository.dart';
import 'package:runnoter/data/interface/repository/workout_repository.dart';
import 'package:runnoter/ui/cubit/calendar_user_data_cubit.dart';

import '../../creators/activity_status_creator.dart';
import '../../creators/health_measurement_creator.dart';
import '../../creators/race_creator.dart';
import '../../creators/workout_creator.dart';
import '../../mock/domain/repository/mock_health_measurement_repository.dart';
import '../../mock/domain/repository/mock_race_repository.dart';
import '../../mock/domain/repository/mock_workout_repository.dart';

void main() {
  final healthMeasurementRepository = MockHealthMeasurementRepository();
  final workoutRepository = MockWorkoutRepository();
  final raceRepository = MockRaceRepository();
  const String userId = 'u1';

  setUpAll(() {
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
  });

  blocTest(
    'number of activities, '
    'should sum all activities',
    build: () => CalendarUserDataCubit(
      userId: userId,
      initialUserData: CalendarUserData(
        healthMeasurements: const [],
        workouts: [
          createWorkout(id: 'w1'),
          createWorkout(id: 'w3'),
          createWorkout(id: 'w2')
        ],
        races: [createRace(id: 'c1'), createRace(id: 'c2')],
      ),
    ),
    verify: (bloc) => expect(bloc.numberOfActivities, 5),
  );

  blocTest(
    'scheduled total distance, '
    'should sum distance of all activities',
    build: () => CalendarUserDataCubit(
      userId: userId,
      initialUserData: CalendarUserData(
        healthMeasurements: const [],
        workouts: [
          createWorkout(
            id: 'w1',
            stages: [
              const WorkoutStageCardio(distanceInKm: 5.2, maxHeartRate: 150),
            ],
          ),
          createWorkout(
            id: 'w3',
            stages: [
              const WorkoutStageCardio(distanceInKm: 2.5, maxHeartRate: 150),
            ],
          ),
          createWorkout(
            id: 'w2',
            stages: [
              const WorkoutStageHillRepeats(
                amountOfSeries: 10,
                seriesDistanceInMeters: 200,
                walkingDistanceInMeters: 100,
                joggingDistanceInMeters: 200,
              ),
            ],
          )
        ],
        races: [
          createRace(id: 'c1', distance: 10.0),
          createRace(id: 'c2', distance: 2.0),
        ],
      ),
    ),
    verify: (bloc) => expect(bloc.scheduledTotalDistance, 24.7),
  );

  blocTest(
    'covered total distance, '
    'should sum covered distance of all activities',
    build: () => CalendarUserDataCubit(
      userId: userId,
      initialUserData: CalendarUserData(
        healthMeasurements: const [],
        workouts: [
          createWorkout(
            id: 'w1',
            status: createActivityStatusDone(coveredDistanceInKm: 5.2),
          ),
          createWorkout(
            id: 'w3',
            status: createActivityStatusAborted(coveredDistanceInKm: 2.5),
          ),
          createWorkout(id: 'w2', status: const ActivityStatusPending())
        ],
        races: [
          createRace(
            id: 'c1',
            status: createActivityStatusDone(coveredDistanceInKm: 10.0),
          ),
          createRace(id: 'c2', status: const ActivityStatusUndone()),
        ],
      ),
    ),
    verify: (bloc) => expect(bloc.coveredTotalDistance, 17.7),
  );

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
        build: () => CalendarUserDataCubit(userId: userId),
        setUp: () {
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
          CalendarUserData(
            healthMeasurements: healthMeasurements,
            workouts: workouts,
            races: races,
          ),
          CalendarUserData(
            healthMeasurements: const [],
            workouts: workouts,
            races: races,
          ),
          CalendarUserData(
            healthMeasurements: const [],
            workouts: updatedWorkouts,
            races: races,
          ),
          CalendarUserData(
            healthMeasurements: const [],
            workouts: updatedWorkouts,
            races: updatedRaces,
          ),
        ],
        verify: (_) {
          verify(
            () => healthMeasurementRepository.getMeasurementsByDateRange(
              startDate: startDate,
              endDate: endDate,
              userId: userId,
            ),
          ).called(1);
          verify(
            () => workoutRepository.getWorkoutsByDateRange(
              startDate: startDate,
              endDate: endDate,
              userId: userId,
            ),
          ).called(1);
          verify(
            () => raceRepository.getRacesByDateRange(
              startDate: startDate,
              endDate: endDate,
              userId: userId,
            ),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'refresh, '
    'should call workout repository method to refresh workouts by date range, '
    'should call race repository method to refresh races by date range, '
    'should call health measurement repository method to refresh health '
    'measurements by date range',
    build: () => CalendarUserDataCubit(userId: userId),
    setUp: () {
      workoutRepository.mockRefreshWorkoutsByDateRange();
      raceRepository.mockRefreshRacesByDateRange();
      healthMeasurementRepository.mockRefreshMeasurementsByDateRange();
    },
    act: (cubit) => cubit.refresh(
      startDate: DateTime(2023, 1, 10),
      endDate: DateTime(2023, 1, 17),
    ),
    expect: () => [],
    verify: (_) {
      verify(
        () => workoutRepository.refreshWorkoutsByDateRange(
          startDate: DateTime(2023, 1, 10),
          endDate: DateTime(2023, 1, 17),
          userId: userId,
        ),
      ).called(1);
      verify(
        () => raceRepository.refreshRacesByDateRange(
          startDate: DateTime(2023, 1, 10),
          endDate: DateTime(2023, 1, 17),
          userId: userId,
        ),
      ).called(1);
      verify(
        () => healthMeasurementRepository.refreshMeasurementsByDateRange(
          startDate: DateTime(2023, 1, 10),
          endDate: DateTime(2023, 1, 17),
          userId: userId,
        ),
      ).called(1);
    },
  );
}
