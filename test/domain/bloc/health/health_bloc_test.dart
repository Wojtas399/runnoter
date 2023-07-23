import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/health/health_bloc.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';
import 'package:runnoter/domain/repository/health_measurement_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/service/health_chart_service.dart';

import '../../../creators/health_measurement_creator.dart';
import '../../../mock/common/mock_date_service.dart';
import '../../../mock/domain/repository/mock_health_measurement_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/service/mock_chart_service.dart';

void main() {
  final dateService = MockDateService();
  final authService = MockAuthService();
  final healthMeasurementRepository = MockHealthMeasurementRepository();
  final chartService = MockHealthChartService();
  const String loggedUserId = 'u1';

  HealthBloc createBloc({
    ChartRange chartRange = ChartRange.week,
    HealthMeasurement? todayMeasurement,
    DateTime? chartStartDate,
    DateTime? chartEndDate,
  }) =>
      HealthBloc(
        dateService: dateService,
        chartService: chartService,
        state: HealthState(
          status: const BlocStatusInitial(),
          chartRange: chartRange,
          todayMeasurement: todayMeasurement,
          chartStartDate: chartStartDate,
          chartEndDate: chartEndDate,
        ),
      );

  HealthState createState({
    BlocStatus status = const BlocStatusInitial(),
    ChartRange chartRange = ChartRange.week,
    HealthMeasurement? todayMeasurement,
    DateTime? chartStartDate,
    DateTime? chartEndDate,
    List<HealthChartPoint>? restingHeartRatePoints,
    List<HealthChartPoint>? fastingWeightPoints,
  }) =>
      HealthState(
        status: status,
        chartRange: chartRange,
        todayMeasurement: todayMeasurement,
        chartStartDate: chartStartDate,
        chartEndDate: chartEndDate,
        restingHeartRatePoints: restingHeartRatePoints,
        fastingWeightPoints: fastingWeightPoints,
      );

  setUpAll(() {
    GetIt.I.registerSingleton<AuthService>(authService);
    GetIt.I.registerSingleton<HealthMeasurementRepository>(
      healthMeasurementRepository,
    );
  });

  tearDown(() {
    reset(dateService);
    reset(authService);
    reset(healthMeasurementRepository);
    reset(chartService);
  });

  blocTest(
    'initialize, '
    'should set listeners of today health measurement and health measurements from this week',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockGetMeasurementByDate(
        measurement: createHealthMeasurement(
          date: DateTime(2023, 5, 12),
          restingHeartRate: 49,
          fastingWeight: 60.5,
        ),
      );
      dateService.mockGetToday(
        todayDate: DateTime(2023, 5, 12),
      );
      dateService.mockGetFirstDayOfTheWeek(
        date: DateTime(2023, 5, 8),
      );
      dateService.mockGetLastDayOfTheWeek(
        date: DateTime(2023, 5, 14),
      );
      healthMeasurementRepository.mockGetMeasurementsByDateRange(
        measurements: [
          createHealthMeasurement(
            date: DateTime(2023, 5, 9),
            restingHeartRate: 50,
            fastingWeight: 60.2,
          ),
          createHealthMeasurement(
            date: DateTime(2023, 5, 11),
            restingHeartRate: 53,
            fastingWeight: 64,
          ),
        ],
      );
      chartService.mockCreatePointsOfCharts(points: ([], []));
    },
    act: (bloc) => bloc.add(const HealthEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        chartRange: ChartRange.week,
        chartStartDate: DateTime(2023, 5, 8),
        chartEndDate: DateTime(2023, 5, 14),
      ),
      createState(
        status: const BlocStatusComplete(),
        chartRange: ChartRange.week,
        todayMeasurement: createHealthMeasurement(
          date: DateTime(2023, 5, 12),
          restingHeartRate: 49,
          fastingWeight: 60.5,
        ),
        chartStartDate: DateTime(2023, 5, 8),
        chartEndDate: DateTime(2023, 5, 14),
      ),
      createState(
        status: const BlocStatusComplete(),
        chartRange: ChartRange.week,
        todayMeasurement: createHealthMeasurement(
          date: DateTime(2023, 5, 12),
          restingHeartRate: 49,
          fastingWeight: 60.5,
        ),
        chartStartDate: DateTime(2023, 5, 8),
        chartEndDate: DateTime(2023, 5, 14),
        restingHeartRatePoints: [],
        fastingWeightPoints: [],
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(2);
      verify(
        () => healthMeasurementRepository.getMeasurementByDate(
          date: DateTime(2023, 5, 12),
          userId: loggedUserId,
        ),
      ).called(1);
      verify(
        () => healthMeasurementRepository.getMeasurementsByDateRange(
          startDate: DateTime(2023, 5, 8),
          endDate: DateTime(2023, 5, 14),
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'measurements from date range updated, '
    'should update in state created resting heart rate points and fasting weight points',
    build: () => createBloc(
      chartStartDate: DateTime(2023, 5, 8),
      chartEndDate: DateTime(2023, 5, 10),
    ),
    setUp: () {
      chartService.mockCreatePointsOfCharts(
        points: (
          [
            HealthChartPoint(date: DateTime(2023, 5, 8), value: 50),
            HealthChartPoint(date: DateTime(2023, 5, 9), value: 51),
            HealthChartPoint(date: DateTime(2023, 5, 10), value: 52),
          ],
          [
            HealthChartPoint(date: DateTime(2023, 5, 8), value: 60.5),
            HealthChartPoint(date: DateTime(2023, 5, 9), value: 62),
            HealthChartPoint(date: DateTime(2023, 5, 10), value: 61.3),
          ],
        ),
      );
    },
    act: (bloc) => bloc.add(HealthEventMeasurementsFromDateRangeUpdated(
      measurements: [
        createHealthMeasurement(date: DateTime(2023, 5, 8)),
        createHealthMeasurement(date: DateTime(2023, 5, 10)),
      ],
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        chartStartDate: DateTime(2023, 5, 8),
        chartEndDate: DateTime(2023, 5, 10),
        restingHeartRatePoints: [
          HealthChartPoint(date: DateTime(2023, 5, 8), value: 50),
          HealthChartPoint(date: DateTime(2023, 5, 9), value: 51),
          HealthChartPoint(date: DateTime(2023, 5, 10), value: 52),
        ],
        fastingWeightPoints: [
          HealthChartPoint(date: DateTime(2023, 5, 8), value: 60.5),
          HealthChartPoint(date: DateTime(2023, 5, 9), value: 62),
          HealthChartPoint(date: DateTime(2023, 5, 10), value: 61.3),
        ],
      ),
    ],
    verify: (_) => verify(
      () => chartService.createPointsOfCharts(
        chartRange: ChartRange.week,
        startDate: DateTime(2023, 5, 8),
        endDate: DateTime(2023, 5, 10),
        measurements: [
          createHealthMeasurement(date: DateTime(2023, 5, 8)),
          createHealthMeasurement(date: DateTime(2023, 5, 10)),
        ],
      ),
    ).called(1),
  );

  blocTest(
    'add today measurement, '
    'should call method from health measurement repository responsible for adding measurement with today date',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockAddMeasurement();
      dateService.mockGetToday(todayDate: DateTime(2023, 5, 12));
    },
    act: (bloc) => bloc.add(const HealthEventAddTodayMeasurement(
      restingHeartRate: 50,
      fastingWeight: 60.5,
    )),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete<HealthBlocInfo>(
          info: HealthBlocInfo.healthMeasurementAdded,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => healthMeasurementRepository.addMeasurement(
          measurement: HealthMeasurement(
            userId: loggedUserId,
            date: DateTime(2023, 5, 12),
            restingHeartRate: 50,
            fastingWeight: 60.5,
          ),
        ),
      ).called(1);
    },
  );

  blocTest(
    'delete today measurement, '
    'should call method from health measurement repository responsible for deleting measurement with today date',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockDeleteMeasurement();
      dateService.mockGetToday(todayDate: DateTime(2023, 5, 12));
    },
    act: (bloc) => bloc.add(const HealthEventDeleteTodayMeasurement()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete<HealthBlocInfo>(
          info: HealthBlocInfo.healthMeasurementDeleted,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => healthMeasurementRepository.deleteMeasurement(
          userId: loggedUserId,
          date: DateTime(2023, 5, 12),
        ),
      ).called(1);
    },
  );

  blocTest(
    'change chart range type, '
    'should update new computed range in state and should set new listener of measurements from new date range',
    build: () => createBloc(),
    setUp: () {
      chartService.mockComputeNewRange(
        range: (DateTime(2023, 5, 8), DateTime(2023, 5, 14)),
      );
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockGetMeasurementsByDateRange();
    },
    act: (bloc) => bloc.add(const HealthEventChangeChartRangeType(
      chartRangeType: ChartRange.week,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        chartRange: ChartRange.week,
        chartStartDate: DateTime(2023, 5, 8),
        chartEndDate: DateTime(2023, 5, 14),
      ),
    ],
    verify: (_) {
      verify(
        () => chartService.computeNewRange(
          chartRange: ChartRange.week,
        ),
      ).called(1);
      verify(
        () => healthMeasurementRepository.getMeasurementsByDateRange(
          startDate: DateTime(2023, 5, 8),
          endDate: DateTime(2023, 5, 14),
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'previous chart range, '
    'should update new computed range in state and should set new listener of measurements from new date range',
    build: () => createBloc(
      chartRange: ChartRange.week,
      chartStartDate: DateTime(2023, 5, 8),
      chartEndDate: DateTime(2023, 5, 14),
    ),
    setUp: () {
      chartService.mockComputePreviousRange(
        previousRange: (DateTime(2023, 5, 1), DateTime(2023, 5, 7)),
      );
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockGetMeasurementsByDateRange();
    },
    act: (bloc) => bloc.add(const HealthEventPreviousChartRange()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        chartRange: ChartRange.week,
        chartStartDate: DateTime(2023, 5, 1),
        chartEndDate: DateTime(2023, 5, 7),
      ),
    ],
    verify: (_) {
      verify(
        () => chartService.computePreviousRange(
          startDate: DateTime(2023, 5, 8),
          endDate: DateTime(2023, 5, 14),
          chartRange: ChartRange.week,
        ),
      ).called(1);
      verify(
        () => healthMeasurementRepository.getMeasurementsByDateRange(
          startDate: DateTime(2023, 5, 1),
          endDate: DateTime(2023, 5, 7),
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'next chart range, '
    'should update new computed range in state and should set new listener of measurements from new date range',
    build: () => createBloc(
      chartRange: ChartRange.week,
      chartStartDate: DateTime(2023, 5, 8),
      chartEndDate: DateTime(2023, 5, 14),
    ),
    setUp: () {
      chartService.mockComputeNextRange(
        nextRange: (DateTime(2023, 5, 15), DateTime(2023, 5, 21)),
      );
      authService.mockGetLoggedUserId(userId: loggedUserId);
      healthMeasurementRepository.mockGetMeasurementsByDateRange();
    },
    act: (bloc) => bloc.add(const HealthEventNextChartRange()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        chartRange: ChartRange.week,
        chartStartDate: DateTime(2023, 5, 15),
        chartEndDate: DateTime(2023, 5, 21),
      ),
    ],
    verify: (_) {
      verify(
        () => chartService.computeNextRange(
          startDate: DateTime(2023, 5, 8),
          endDate: DateTime(2023, 5, 14),
          chartRange: ChartRange.week,
        ),
      ).called(1);
      verify(
        () => healthMeasurementRepository.getMeasurementsByDateRange(
          startDate: DateTime(2023, 5, 15),
          endDate: DateTime(2023, 5, 21),
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );
}
