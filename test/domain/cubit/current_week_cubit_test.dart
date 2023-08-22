import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/domain/additional_model/activity_status.dart';
import 'package:runnoter/domain/additional_model/calendar_date_range_data.dart';
import 'package:runnoter/domain/additional_model/workout_stage.dart';
import 'package:runnoter/domain/cubit/current_week_cubit.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';
import 'package:runnoter/domain/entity/race.dart';
import 'package:runnoter/domain/entity/workout.dart';
import 'package:runnoter/domain/repository/health_measurement_repository.dart';
import 'package:runnoter/domain/repository/race_repository.dart';
import 'package:runnoter/domain/repository/workout_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../creators/activity_status_creator.dart';
import '../../creators/health_measurement_creator.dart';
import '../../creators/race_creator.dart';
import '../../creators/workout_creator.dart';
import '../../mock/common/mock_date_service.dart';
import '../../mock/domain/repository/mock_health_measurement_repository.dart';
import '../../mock/domain/repository/mock_race_repository.dart';
import '../../mock/domain/repository/mock_workout_repository.dart';
import '../../mock/domain/service/mock_auth_service.dart';

void main() {
  final dateService = MockDateService();
  final authService = MockAuthService();
  final healthMeasurementRepository = MockHealthMeasurementRepository();
  final workoutRepository = MockWorkoutRepository();
  final raceRepository = MockRaceRepository();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<DateService>(() => dateService);
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<HealthMeasurementRepository>(
      healthMeasurementRepository,
    );
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
  });

  tearDown(() {
    reset(dateService);
    reset(authService);
    reset(healthMeasurementRepository);
    reset(workoutRepository);
    reset(raceRepository);
  });

  blocTest(
    'number of activities, '
    'should sum all activities',
    build: () => CurrentWeekCubit(
      dateRangeData: CalendarDateRangeData(
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
    build: () => CurrentWeekCubit(
      dateRangeData: CalendarDateRangeData(
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
    build: () => CurrentWeekCubit(
      dateRangeData: CalendarDateRangeData(
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
    'initialize',
    () {
      final DateTime startDate = DateTime(2023, 4, 3);
      final DateTime endDate = DateTime(2023, 4, 9);
      final List<HealthMeasurement> healthMeasurements = [
        createHealthMeasurement(date: DateTime(2023, 4, 5)),
        createHealthMeasurement(date: DateTime(2023, 4, 7)),
      ];
      final List<Workout> workouts = [
        createWorkout(id: 'w1'),
        createWorkout(id: 'w2'),
        createWorkout(id: 'w3'),
      ];
      final List<Race> races = [
        createRace(id: 'c1', date: DateTime(2023, 4, 5)),
        createRace(id: 'c2', date: DateTime(2023, 4, 6)),
      ];
      final StreamController<List<HealthMeasurement>> healthMeasurements$ =
          StreamController()..add(healthMeasurements);
      final StreamController<List<Workout>> workouts$ = StreamController()
        ..add(workouts);
      final StreamController<List<Race>> races$ = StreamController()
        ..add(races);

      blocTest(
        "should set listener of logged user's health measurements, workouts and races from current week",
        build: () => CurrentWeekCubit(),
        setUp: () {
          dateService.mockGetToday(todayDate: DateTime(2023, 4, 5));
          dateService.mockGetFirstDayOfTheWeek(date: startDate);
          dateService.mockGetLastDayOfTheWeek(date: endDate);
          authService.mockGetLoggedUserId(userId: loggedUserId);
          healthMeasurementRepository.mockGetMeasurementsByDateRange(
            measurementsStream: healthMeasurements$.stream,
          );
          workoutRepository.mockGetWorkoutsByDateRange(
            workoutsStream: workouts$.stream,
          );
          raceRepository.mockGetRacesByDateRange(racesStream: races$.stream);
        },
        act: (cubit) {
          cubit.initialize();
          healthMeasurements$.add([]);
          workouts$.add([]);
          races$.add([]);
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
            workouts: const [],
            races: races,
          ),
          const CalendarDateRangeData(
            healthMeasurements: [],
            workouts: [],
            races: [],
          ),
        ],
        verify: (_) {
          verify(
            () => authService.loggedUserId$,
          ).called(1);
          verify(
            () => healthMeasurementRepository.getMeasurementsByDateRange(
              userId: loggedUserId,
              startDate: startDate,
              endDate: endDate,
            ),
          ).called(1);
          verify(
            () => workoutRepository.getWorkoutsByDateRange(
              userId: loggedUserId,
              startDate: startDate,
              endDate: endDate,
            ),
          ).called(1);
          verify(
            () => raceRepository.getRacesByDateRange(
              userId: loggedUserId,
              startDate: startDate,
              endDate: endDate,
            ),
          ).called(1);
        },
      );
    },
  );
}
