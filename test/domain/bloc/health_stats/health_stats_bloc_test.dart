import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/domain/bloc/health_stats/health_stats_bloc.dart';
import 'package:runnoter/domain/cubit/chart_date_range_cubit.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';
import 'package:runnoter/domain/repository/health_measurement_repository.dart';

import '../../../creators/health_measurement_creator.dart';
import '../../../mock/common/mock_date_service.dart';
import '../../../mock/domain/cubit/mock_chart_date_range_cubit.dart';
import '../../../mock/domain/repository/mock_health_measurement_repository.dart';

void main() {
  final dateService = MockDateService();
  final healthMeasurementRepository = MockHealthMeasurementRepository();
  final chartDateRangeCubit = MockChartDateRangeCubit();
  const String userId = 'u1';

  HealthStatsBloc createBloc() => HealthStatsBloc(userId: userId);

  setUpAll(() {
    GetIt.I.registerFactory<DateService>(() => dateService);
    GetIt.I.registerSingleton<HealthMeasurementRepository>(
      healthMeasurementRepository,
    );
    GetIt.I.registerFactory<ChartDateRangeCubit>(() => chartDateRangeCubit);
  });

  tearDown(() {
    reset(dateService);
    reset(healthMeasurementRepository);
    reset(chartDateRangeCubit);
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
        dateRangeType: DateRangeType.month,
        dateRange: DateRange(
          startDate: DateTime(2023, 8),
          endDate: DateTime(2023, 8, 31),
        ),
      );
      final StreamController<ChartDateRangeState> chartDateRange$ =
          StreamController()..add(chartDateRange);
      final expectedPoints = List<HealthStatsChartPoint>.generate(
        7,
        (index) => HealthStatsChartPoint(
          date: DateTime(2023, 8, 21 + index),
          value: null,
        ),
      );
      final expectedUpdatedPoints = List<HealthStatsChartPoint>.generate(
        31,
        (index) => HealthStatsChartPoint(
          date: DateTime(2023, 8, 1 + index),
          value: null,
        ),
      );

      blocTest(
        'should call chart date range method to initialize date range with week type and '
        'should set listener of chart date range state',
        build: () => createBloc(),
        setUp: () {
          chartDateRangeCubit.mockStream(
            expectedStream: chartDateRange$.stream,
          );
          healthMeasurementRepository.mockGetMeasurementsByDateRange();
          dateService.mockAreDatesTheSame(expected: false);
          when(
            () => dateService.areDatesTheSame(
              DateTime(2023, 8, 28),
              DateTime(2023, 8, 28),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areDatesTheSame(
              DateTime(2023, 9),
              DateTime(2023, 9),
            ),
          ).thenReturn(true);
        },
        act: (bloc) async {
          bloc.add(const HealthStatsEventInitialize());
          await bloc.stream.first;
          chartDateRange$.add(updatedChartDateRange);
        },
        expect: () => [
          HealthStatsState(
            dateRangeType: DateRangeType.week,
            dateRange: DateRange(
              startDate: DateTime(2023, 8, 21),
              endDate: DateTime(2023, 8, 27),
            ),
            restingHeartRatePoints: expectedPoints,
            fastingWeightPoints: expectedPoints,
          ),
          HealthStatsState(
            dateRangeType: DateRangeType.month,
            dateRange: DateRange(
              startDate: DateTime(2023, 8),
              endDate: DateTime(2023, 8, 31),
            ),
            restingHeartRatePoints: expectedUpdatedPoints,
            fastingWeightPoints: expectedUpdatedPoints,
          ),
        ],
        verify: (_) {
          verify(
            () => chartDateRangeCubit.initializeNewDateRangeType(
              DateRangeType.week,
            ),
          ).called(1);
          verify(() => chartDateRangeCubit.stream).called(1);
        },
      );
    },
  );

  group(
    'chart date range updated, '
    'week range',
    () {
      final DateTime startDate = DateTime(2023, 5, 8);
      final DateTime endDate = DateTime(2023, 5, 12);
      final List<HealthMeasurement> healthMeasurements = [
        createHealthMeasurement(
          date: DateTime(2023, 5, 9),
          restingHeartRate: 51,
          fastingWeight: 60.5,
        ),
        createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 53,
          fastingWeight: 64,
        ),
        createHealthMeasurement(
          date: endDate,
          restingHeartRate: 52,
          fastingWeight: 62.5,
        ),
      ];
      final List<HealthStatsChartPoint> expectedRestingHeartRatePoints = [
        HealthStatsChartPoint(date: startDate, value: null),
        HealthStatsChartPoint(date: DateTime(2023, 5, 9), value: 51),
        HealthStatsChartPoint(date: DateTime(2023, 5, 10), value: 53),
        HealthStatsChartPoint(date: DateTime(2023, 5, 11), value: null),
        HealthStatsChartPoint(date: endDate, value: 52),
      ];
      final List<HealthStatsChartPoint> expectedFastingWeightPoints = [
        HealthStatsChartPoint(date: startDate, value: null),
        HealthStatsChartPoint(date: DateTime(2023, 5, 9), value: 60.5),
        HealthStatsChartPoint(date: DateTime(2023, 5, 10), value: 64.0),
        HealthStatsChartPoint(date: DateTime(2023, 5, 11), value: null),
        HealthStatsChartPoint(date: endDate, value: 62.5),
      ];
      final List<HealthStatsChartPoint> expectedUpdatedPoints = [
        HealthStatsChartPoint(date: startDate, value: null),
        HealthStatsChartPoint(date: DateTime(2023, 5, 9), value: null),
        HealthStatsChartPoint(date: DateTime(2023, 5, 10), value: null),
        HealthStatsChartPoint(date: DateTime(2023, 5, 11), value: null),
        HealthStatsChartPoint(date: endDate, value: null),
      ];
      final StreamController<List<HealthMeasurement>> healthMeasurements$ =
          StreamController()..add(healthMeasurements);

      blocTest(
        'should set listener of health measurements from given date range and '
        'should create points of all days of the week',
        build: () => createBloc(),
        setUp: () {
          healthMeasurementRepository.mockGetMeasurementsByDateRange(
            measurementsStream: healthMeasurements$.stream,
          );
          dateService.mockAreDatesTheSame(expected: false);
          when(
            () => dateService.areDatesTheSame(
              DateTime(2023, 5, 9),
              DateTime(2023, 5, 9),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areDatesTheSame(
              DateTime(2023, 5, 10),
              DateTime(2023, 5, 10),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areDatesTheSame(
              DateTime(2023, 5, 12),
              DateTime(2023, 5, 12),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areDatesTheSame(
              DateTime(2023, 5, 13),
              DateTime(2023, 5, 13),
            ),
          ).thenReturn(true);
        },
        act: (bloc) {
          bloc.add(
            HealthStatsEventChartDateRangeUpdated(
              chartDateRange: ChartDateRangeState(
                dateRangeType: DateRangeType.week,
                dateRange: DateRange(startDate: startDate, endDate: endDate),
              ),
            ),
          );
          healthMeasurements$.add([]);
        },
        expect: () => [
          HealthStatsState(
            dateRangeType: DateRangeType.week,
            dateRange: DateRange(startDate: startDate, endDate: endDate),
            restingHeartRatePoints: expectedRestingHeartRatePoints,
            fastingWeightPoints: expectedFastingWeightPoints,
          ),
          HealthStatsState(
            dateRangeType: DateRangeType.week,
            dateRange: DateRange(startDate: startDate, endDate: endDate),
            restingHeartRatePoints: expectedUpdatedPoints,
            fastingWeightPoints: expectedUpdatedPoints,
          ),
        ],
        verify: (_) => verify(
          () => healthMeasurementRepository.getMeasurementsByDateRange(
            startDate: startDate,
            endDate: endDate,
            userId: userId,
          ),
        ).called(1),
      );
    },
  );

  group(
    'chart date range updated, '
    'month range',
    () {
      final DateTime startDate = DateTime(2023, 5, 1);
      final DateTime endDate = DateTime(2023, 5, 31);
      final List<HealthMeasurement> healthMeasurements = [
        createHealthMeasurement(
          date: DateTime(2023, 5, 9),
          restingHeartRate: 51,
          fastingWeight: 60.5,
        ),
        createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 53,
          fastingWeight: 64,
        ),
        createHealthMeasurement(
          date: endDate,
          restingHeartRate: 52,
          fastingWeight: 62.5,
        ),
      ];
      final expectedRestingHeartRatePoints =
          List<HealthStatsChartPoint>.generate(
        31,
        (index) => HealthStatsChartPoint(
          date: DateTime(2023, 5, index + 1),
          value: switch (index) {
            8 => 51,
            9 => 53,
            30 => 52,
            int() => null,
          },
        ),
      );
      final expectedFastingWeightPoints = List<HealthStatsChartPoint>.generate(
        31,
        (index) => HealthStatsChartPoint(
          date: DateTime(2023, 5, index + 1),
          value: switch (index) {
            8 => 60.5,
            9 => 64.0,
            30 => 62.5,
            int() => null,
          },
        ),
      );
      final List<HealthStatsChartPoint> expectedUpdatedPoints =
          List<HealthStatsChartPoint>.generate(
        31,
        (index) => HealthStatsChartPoint(
          date: DateTime(2023, 5, index + 1),
          value: null,
        ),
      );
      final StreamController<List<HealthMeasurement>> healthMeasurements$ =
          StreamController()..add(healthMeasurements);

      blocTest(
        'should set listener of health measurements from given date range and '
        'should create points of all days of the month',
        build: () => createBloc(),
        setUp: () {
          healthMeasurementRepository.mockGetMeasurementsByDateRange(
            measurementsStream: healthMeasurements$.stream,
          );
          dateService.mockAreDatesTheSame(expected: false);
          when(
            () => dateService.areDatesTheSame(
              DateTime(2023, 5, 9),
              DateTime(2023, 5, 9),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areDatesTheSame(
              DateTime(2023, 5, 10),
              DateTime(2023, 5, 10),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areDatesTheSame(
              DateTime(2023, 5, 31),
              DateTime(2023, 5, 31),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areDatesTheSame(
              DateTime(2023, 6, 1),
              DateTime(2023, 6, 1),
            ),
          ).thenReturn(true);
        },
        act: (bloc) {
          bloc.add(
            HealthStatsEventChartDateRangeUpdated(
              chartDateRange: ChartDateRangeState(
                dateRangeType: DateRangeType.month,
                dateRange: DateRange(startDate: startDate, endDate: endDate),
              ),
            ),
          );
          healthMeasurements$.add([]);
        },
        expect: () => [
          HealthStatsState(
            dateRangeType: DateRangeType.month,
            dateRange: DateRange(startDate: startDate, endDate: endDate),
            restingHeartRatePoints: expectedRestingHeartRatePoints,
            fastingWeightPoints: expectedFastingWeightPoints,
          ),
          HealthStatsState(
            dateRangeType: DateRangeType.month,
            dateRange: DateRange(startDate: startDate, endDate: endDate),
            restingHeartRatePoints: expectedUpdatedPoints,
            fastingWeightPoints: expectedUpdatedPoints,
          ),
        ],
        verify: (_) => verify(
          () => healthMeasurementRepository.getMeasurementsByDateRange(
            startDate: startDate,
            endDate: endDate,
            userId: userId,
          ),
        ).called(1),
      );
    },
  );

  group(
    'chart date range updated, '
    'year range',
    () {
      final DateTime startDate = DateTime(2023, 1, 1);
      final DateTime endDate = DateTime(2023, 12, 31);
      final List<HealthMeasurement> healthMeasurements = [
        createHealthMeasurement(
          date: DateTime(2023, 5, 9),
          restingHeartRate: 51,
          fastingWeight: 60.5,
        ),
        createHealthMeasurement(
          date: DateTime(2023, 5, 10),
          restingHeartRate: 53,
          fastingWeight: 64,
        ),
        createHealthMeasurement(
          date: DateTime(2023, 5, 11),
          restingHeartRate: 52,
          fastingWeight: 62.5,
        ),
        createHealthMeasurement(
          date: DateTime(2023, 4, 9),
          restingHeartRate: 49,
          fastingWeight: 58.5,
        ),
        createHealthMeasurement(
          date: DateTime(2023, 4, 10),
          restingHeartRate: 51,
          fastingWeight: 62,
        ),
        createHealthMeasurement(
          date: DateTime(2023, 4, 11),
          restingHeartRate: 50,
          fastingWeight: 60.5,
        ),
      ];
      final expectedRestingHeartRatePoints =
          List<HealthStatsChartPoint>.generate(
        12,
        (index) => HealthStatsChartPoint(
          date: DateTime(2023, index + 1),
          value: switch (index) {
            3 => (49 + 51 + 50) / 3,
            4 => (51 + 53 + 52) / 3,
            int() => null,
          },
        ),
      );
      final expectedFastingWeightPoints = List<HealthStatsChartPoint>.generate(
        12,
        (index) => HealthStatsChartPoint(
          date: DateTime(2023, index + 1),
          value: switch (index) {
            3 => (58.5 + 62 + 60.5) / 3,
            4 => (60.5 + 64 + 62.5) / 3,
            int() => null,
          },
        ),
      );
      final expectedUpdatedPoints = List<HealthStatsChartPoint>.generate(
        12,
        (index) => HealthStatsChartPoint(
          date: DateTime(2023, index + 1),
          value: null,
        ),
      );
      final StreamController<List<HealthMeasurement>> healthMeasurements$ =
          StreamController()..add(healthMeasurements);

      blocTest(
        'should set listener of health measurements from given date range and '
        'should create points of all months of the year with average values',
        build: () => createBloc(),
        setUp: () {
          healthMeasurementRepository.mockGetMeasurementsByDateRange(
            measurementsStream: healthMeasurements$.stream,
          );
          dateService.mockGetFirstDayOfTheYear(date: startDate);
        },
        act: (bloc) {
          bloc.add(
            HealthStatsEventChartDateRangeUpdated(
              chartDateRange: ChartDateRangeState(
                dateRangeType: DateRangeType.year,
                dateRange: DateRange(startDate: startDate, endDate: endDate),
              ),
            ),
          );
          healthMeasurements$.add([]);
        },
        expect: () => [
          HealthStatsState(
            dateRangeType: DateRangeType.year,
            dateRange: DateRange(startDate: startDate, endDate: endDate),
            restingHeartRatePoints: expectedRestingHeartRatePoints,
            fastingWeightPoints: expectedFastingWeightPoints,
          ),
          HealthStatsState(
            dateRangeType: DateRangeType.year,
            dateRange: DateRange(startDate: startDate, endDate: endDate),
            restingHeartRatePoints: expectedUpdatedPoints,
            fastingWeightPoints: expectedUpdatedPoints,
          ),
        ],
        verify: (_) => verify(
          () => healthMeasurementRepository.getMeasurementsByDateRange(
            startDate: startDate,
            endDate: endDate,
            userId: userId,
          ),
        ).called(1),
      );
    },
  );

  blocTest(
    'change chart date range type, '
    "should call chart date range cubit's method to initialize new date range type",
    build: () => createBloc(),
    act: (bloc) => bloc.add(const HealthStatsEventChangeChartDateRangeType(
      dateRangeType: DateRangeType.month,
    )),
    expect: () => [],
    verify: (_) => verify(
      () => chartDateRangeCubit.initializeNewDateRangeType(DateRangeType.month),
    ).called(1),
  );

  blocTest(
    'previous chart range, '
    "should call chart date range cubit's method to set previous date range",
    build: () => createBloc(),
    act: (bloc) => bloc.add(const HealthStatsEventPreviousChartDateRange()),
    expect: () => [],
    verify: (_) => verify(chartDateRangeCubit.previousDateRange).called(1),
  );

  blocTest(
    'next chart range, '
    "should call chart date range cubit's method to set next date range",
    build: () => createBloc(),
    act: (bloc) => bloc.add(const HealthStatsEventNextChartDateRange()),
    expect: () => [],
    verify: (_) => verify(chartDateRangeCubit.nextDateRange).called(1),
  );
}
