import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/domain/additional_model/activity_status.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/workout_stage.dart';
import 'package:runnoter/domain/bloc/mileage/mileage_bloc.dart';
import 'package:runnoter/domain/cubit/chart_date_range_cubit.dart';
import 'package:runnoter/domain/entity/race.dart';
import 'package:runnoter/domain/entity/workout.dart';
import 'package:runnoter/domain/repository/race_repository.dart';
import 'package:runnoter/domain/repository/workout_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../creators/activity_status_creator.dart';
import '../../../creators/race_creator.dart';
import '../../../creators/workout_creator.dart';
import '../../../mock/common/mock_date_service.dart';
import '../../../mock/domain/cubit/mock_chart_date_range_cubit.dart';
import '../../../mock/domain/repository/mock_race_repository.dart';
import '../../../mock/domain/repository/mock_workout_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();
  final raceRepository = MockRaceRepository();
  final chartDateRangeCubit = MockChartDateRangeCubit();
  final dateService = MockDateService();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
    GetIt.I.registerFactory<ChartDateRangeCubit>(() => chartDateRangeCubit);
    GetIt.I.registerFactory<DateService>(() => dateService);
  });

  tearDown(() {
    reset(authService);
    reset(workoutRepository);
    reset(raceRepository);
    reset(chartDateRangeCubit);
    reset(dateService);
  });

  group(
    'initialize',
    () {
      final ChartDateRangeState chartDateRange = ChartDateRangeState(
        dateRangeType: DateRangeType.week,
        dateRange: DateRange(
          startDate: DateTime(2023, 8, 21),
          endDate: DateTime(2023, 8, 27),
        ),
      );
      final ChartDateRangeState updatedChartDateRange = ChartDateRangeState(
        dateRangeType: DateRangeType.year,
        dateRange: DateRange(
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 12, 31),
        ),
      );
      final StreamController<ChartDateRangeState> chartDateRange$ =
          StreamController()..add(chartDateRange);
      final expectedPoints = List<MileageChartPoint>.generate(
        7,
        (i) => MileageChartPoint(date: DateTime(2023, 8, 21 + i), mileage: 0.0),
      );
      final expectedUpdatedPoints = List<MileageChartPoint>.generate(
        12,
        (i) => MileageChartPoint(date: DateTime(2023, 1 + i), mileage: 0.0),
      );

      blocTest(
        "should set listener of chart date range cubit's state",
        build: () => MileageBloc(),
        setUp: () {
          chartDateRangeCubit.mockStream(
            expectedStream: chartDateRange$.stream,
          );
          authService.mockGetLoggedUserId(userId: loggedUserId);
          workoutRepository.mockGetWorkoutsByDateRange();
          raceRepository.mockGetRacesByDateRange();
          dateService.mockAreDatesTheSame(expected: false);
        },
        act: (bloc) async {
          bloc.add(const MileageEventInitialize());
          await bloc.stream.first;
          chartDateRange$.add(updatedChartDateRange);
        },
        expect: () => [
          MileageState(
            status: const BlocStatusComplete(),
            dateRangeType: chartDateRange.dateRangeType,
            dateRange: chartDateRange.dateRange,
            mileageChartPoints: expectedPoints,
          ),
          MileageState(
            status: const BlocStatusComplete(),
            dateRangeType: updatedChartDateRange.dateRangeType,
            dateRange: updatedChartDateRange.dateRange,
            mileageChartPoints: expectedUpdatedPoints,
          ),
        ],
        verify: (_) => verify(() => chartDateRangeCubit.stream).called(1),
      );
    },
  );

  group(
    'chart date range updated, '
    'week',
    () {
      final DateTime startDate = DateTime(2023, 8, 21);
      final DateTime endDate = DateTime(2023, 8, 27);
      final List<Workout> workouts = [
        createWorkout(
          id: 'w1',
          date: startDate,
          status: createActivityStatusDone(coveredDistanceInKm: 10),
        ),
        createWorkout(
          id: 'w2',
          date: startDate,
          status: createActivityStatusDone(coveredDistanceInKm: 2),
        ),
        createWorkout(
          id: 'w3',
          date: startDate,
          stages: [
            const WorkoutStageCardio(distanceInKm: 10, maxHeartRate: 150),
          ],
          status: const ActivityStatusUndone(),
        ),
        createWorkout(
          id: 'w4',
          date: DateTime(2023, 8, 23),
          status: createActivityStatusAborted(coveredDistanceInKm: 3),
        ),
        createWorkout(
          id: 'w5',
          date: DateTime(2023, 8, 25),
          status: createActivityStatusDone(coveredDistanceInKm: 5),
        ),
        createWorkout(
          id: 'w6',
          date: DateTime(2023, 8, 25),
          stages: [
            const WorkoutStageZone2(distanceInKm: 10, maxHeartRate: 165),
          ],
          status: const ActivityStatusPending(),
        ),
        createWorkout(
          id: 'w7',
          date: endDate,
          status: createActivityStatusDone(coveredDistanceInKm: 2),
        ),
      ];
      final List<Race> races = [
        createRace(
          id: 'r1',
          date: startDate,
          distance: 10,
          status: const ActivityStatusPending(),
        ),
        createRace(
          id: 'r2',
          date: endDate,
          status: createActivityStatusDone(coveredDistanceInKm: 21),
        ),
      ];
      final StreamController<List<Workout>> workouts$ = StreamController()
        ..add(workouts);
      final StreamController<List<Race>> races$ = StreamController()
        ..add(races);
      final expectedMileageChartPoints = List<MileageChartPoint>.generate(
        7,
        (index) => MileageChartPoint(
          date: DateTime(2023, 8, 21 + index),
          mileage: switch (21 + index) {
            21 => 12,
            23 => 3,
            25 => 5,
            27 => 23,
            int() => 0
          },
        ),
      );
      final secondExpectedMileageChartPoints = List<MileageChartPoint>.generate(
        7,
        (index) => MileageChartPoint(
          date: DateTime(2023, 8, 21 + index),
          mileage: switch (21 + index) { 27 => 21, int() => 0 },
        ),
      );
      final thirdExpectedMileageChartPoints = List<MileageChartPoint>.generate(
        7,
        (index) => MileageChartPoint(
          date: DateTime(2023, 8, 21 + index),
          mileage: 0,
        ),
      );

      blocTest(
        'should set listener of workouts and races from the week and '
        'should calculate mileage for all days from week',
        build: () => MileageBloc(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          workoutRepository.mockGetWorkoutsByDateRange(
            workoutsStream: workouts$.stream,
          );
          raceRepository.mockGetRacesByDateRange(racesStream: races$.stream);
          dateService.mockAreDatesTheSame(expected: false);
          when(
            () => dateService.areDatesTheSame(startDate, startDate),
          ).thenReturn(true);
          when(
            () => dateService.areDatesTheSame(
              DateTime(2023, 8, 23),
              DateTime(2023, 8, 23),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areDatesTheSame(
              DateTime(2023, 8, 25),
              DateTime(2023, 8, 25),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areDatesTheSame(endDate, endDate),
          ).thenReturn(true);
        },
        act: (bloc) async {
          bloc.add(
            MileageEventChartDateRangeUpdated(
              chartDateRange: ChartDateRangeState(
                dateRangeType: DateRangeType.week,
                dateRange: DateRange(startDate: startDate, endDate: endDate),
              ),
            ),
          );
          await bloc.stream.first;
          workouts$.add([]);
          races$.add([]);
        },
        expect: () => [
          MileageState(
            status: const BlocStatusComplete(),
            dateRangeType: DateRangeType.week,
            dateRange: DateRange(startDate: startDate, endDate: endDate),
            mileageChartPoints: expectedMileageChartPoints,
          ),
          MileageState(
            status: const BlocStatusComplete(),
            dateRangeType: DateRangeType.week,
            dateRange: DateRange(startDate: startDate, endDate: endDate),
            mileageChartPoints: secondExpectedMileageChartPoints,
          ),
          MileageState(
            status: const BlocStatusComplete(),
            dateRangeType: DateRangeType.week,
            dateRange: DateRange(startDate: startDate, endDate: endDate),
            mileageChartPoints: thirdExpectedMileageChartPoints,
          ),
        ],
        verify: (_) {
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

  group(
    'chart date range updated, '
    'year',
    () {
      final DateTime startDate = DateTime(2023, 1, 1);
      final DateTime endDate = DateTime(2023, 12, 31);
      final List<Workout> workouts = [
        createWorkout(
          id: 'w1',
          date: DateTime(2023, 1, 10),
          status: createActivityStatusDone(coveredDistanceInKm: 10),
        ),
        createWorkout(
          id: 'w2',
          date: DateTime(2023, 1, 15),
          status: createActivityStatusDone(coveredDistanceInKm: 2),
        ),
        createWorkout(
          id: 'w3',
          date: DateTime(2023, 1, 20),
          status: createActivityStatusAborted(coveredDistanceInKm: 3),
        ),
        createWorkout(
          id: 'w4',
          date: DateTime(2023, 4, 25),
          status: createActivityStatusDone(coveredDistanceInKm: 5),
        ),
        createWorkout(
          id: 'w5',
          date: DateTime(2023, 7, 10),
          status: createActivityStatusDone(coveredDistanceInKm: 2),
        ),
      ];
      final List<Race> races = [
        createRace(
          id: 'r1',
          date: DateTime(2023, 4, 30),
          status: createActivityStatusDone(coveredDistanceInKm: 21),
        ),
        createRace(
          id: 'r2',
          date: DateTime(2023, 8, 2),
          status: createActivityStatusAborted(coveredDistanceInKm: 15),
        ),
      ];
      final StreamController<List<Workout>> workouts$ = StreamController()
        ..add(workouts);
      final StreamController<List<Race>> races$ = StreamController()
        ..add(races);
      final expectedMileageChartPoints = List<MileageChartPoint>.generate(
        12,
        (index) => MileageChartPoint(
          date: DateTime(2023, 1 + index),
          mileage: switch (1 + index) {
            1 => 15,
            4 => 26,
            7 => 2,
            8 => 15,
            int() => 0
          },
        ),
      );
      final secondExpectedMileageChartPoints = List<MileageChartPoint>.generate(
        12,
        (index) => MileageChartPoint(
          date: DateTime(2023, 1 + index),
          mileage: switch (1 + index) { 4 => 21, 8 => 15, int() => 0 },
        ),
      );
      final thirdExpectedMileageChartPoints = List<MileageChartPoint>.generate(
        12,
        (index) =>
            MileageChartPoint(date: DateTime(2023, 1 + index), mileage: 0),
      );

      blocTest(
        'should set listener of workouts and races from the year and '
        'should calculate mileage for all months from the year',
        build: () => MileageBloc(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          workoutRepository.mockGetWorkoutsByDateRange(
            workoutsStream: workouts$.stream,
          );
          raceRepository.mockGetRacesByDateRange(racesStream: races$.stream);
        },
        act: (bloc) {
          bloc.add(
            MileageEventChartDateRangeUpdated(
              chartDateRange: ChartDateRangeState(
                dateRangeType: DateRangeType.year,
                dateRange: DateRange(startDate: startDate, endDate: endDate),
              ),
            ),
          );
          workouts$.add([]);
          races$.add([]);
        },
        expect: () => [
          MileageState(
            status: const BlocStatusComplete(),
            dateRangeType: DateRangeType.year,
            dateRange: DateRange(startDate: startDate, endDate: endDate),
            mileageChartPoints: expectedMileageChartPoints,
          ),
          MileageState(
            status: const BlocStatusComplete(),
            dateRangeType: DateRangeType.year,
            dateRange: DateRange(startDate: startDate, endDate: endDate),
            mileageChartPoints: secondExpectedMileageChartPoints,
          ),
          MileageState(
            status: const BlocStatusComplete(),
            dateRangeType: DateRangeType.year,
            dateRange: DateRange(startDate: startDate, endDate: endDate),
            mileageChartPoints: thirdExpectedMileageChartPoints,
          ),
        ],
        verify: (_) {
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

  blocTest(
    'chart date range updated, '
    'month, '
    'should do nothing',
    build: () => MileageBloc(),
    act: (bloc) => bloc.add(
      MileageEventChartDateRangeUpdated(
        chartDateRange: ChartDateRangeState(
          dateRangeType: DateRangeType.month,
          dateRange: DateRange(
            startDate: DateTime(2023, 1, 1),
            endDate: DateTime(2023, 1, 31),
          ),
        ),
      ),
    ),
    expect: () => [],
  );

  blocTest(
    'chart date range updated, '
    'date range is null, '
    'should do nothing',
    build: () => MileageBloc(),
    act: (bloc) => bloc.add(
      const MileageEventChartDateRangeUpdated(
        chartDateRange: ChartDateRangeState(
          dateRangeType: DateRangeType.week,
          dateRange: null,
        ),
      ),
    ),
    expect: () => [],
  );

  blocTest(
    'change date range type, '
    'week, '
    "should call chart date range cubit's method to initialize new date range type",
    build: () => MileageBloc(),
    act: (bloc) => bloc.add(
      const MileageEventChangeDateRangeType(dateRangeType: DateRangeType.week),
    ),
    verify: (_) => verify(
      () => chartDateRangeCubit.initializeNewDateRangeType(DateRangeType.week),
    ).called(1),
  );

  blocTest(
    'change date range type, '
    'month, '
    "should not call chart date range cubit's method to initialize new date range type",
    build: () => MileageBloc(),
    act: (bloc) => bloc.add(
      const MileageEventChangeDateRangeType(dateRangeType: DateRangeType.month),
    ),
    verify: (_) => verifyNever(
      () => chartDateRangeCubit.initializeNewDateRangeType(DateRangeType.month),
    ),
  );

  blocTest(
    'change date range type, '
    'year, '
    "should call chart date range cubit's method to initialize new date range type",
    build: () => MileageBloc(),
    act: (bloc) => bloc.add(
      const MileageEventChangeDateRangeType(dateRangeType: DateRangeType.year),
    ),
    verify: (_) => verify(
      () => chartDateRangeCubit.initializeNewDateRangeType(DateRangeType.year),
    ).called(1),
  );

  blocTest(
    'previous date range, '
    "should call chart date range cubit's method to set previous date range",
    build: () => MileageBloc(),
    act: (bloc) => bloc.add(const MileageEventPreviousDateRange()),
    verify: (_) => verify(chartDateRangeCubit.previousDateRange).called(1),
  );

  blocTest(
    'next date range, '
    "should call chart date range cubit's method to set next date range",
    build: () => MileageBloc(),
    act: (bloc) => bloc.add(const MileageEventNextDateRange()),
    verify: (_) => verify(chartDateRangeCubit.nextDateRange).called(1),
  );
}
