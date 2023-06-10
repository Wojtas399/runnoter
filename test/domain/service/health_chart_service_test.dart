import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';
import 'package:runnoter/domain/service/health_chart_service.dart';

import '../../creators/health_measurement_creator.dart';
import '../../mock/common/mock_date_service.dart';

void main() {
  final dateService = MockDateService();
  late HealthChartService service;

  setUp(
    () => service = HealthChartService(dateService: dateService),
  );

  tearDown(() {
    reset(dateService);
  });

  test(
    'create points of charts, '
    'week range, '
    'should create points of all days from start date to end date',
    () {
      const ChartRange chartRange = ChartRange.week;
      final DateTime startDate = DateTime(2023, 5, 8);
      final DateTime endDate = DateTime(2023, 5, 12);
      final List<HealthMeasurement> measurements = [
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
      final List<HealthChartPoint> expectedRestingHeartRatePoints = [
        HealthChartPoint(date: startDate, value: null),
        HealthChartPoint(date: DateTime(2023, 5, 9), value: 51),
        HealthChartPoint(date: DateTime(2023, 5, 10), value: 53),
        HealthChartPoint(date: DateTime(2023, 5, 11), value: null),
        HealthChartPoint(date: endDate, value: 52),
      ];
      final List<HealthChartPoint> expectedFastingWeightPoints = [
        HealthChartPoint(date: startDate, value: null),
        HealthChartPoint(date: DateTime(2023, 5, 9), value: 60.5),
        HealthChartPoint(date: DateTime(2023, 5, 10), value: 64.0),
        HealthChartPoint(date: DateTime(2023, 5, 11), value: null),
        HealthChartPoint(date: endDate, value: 62.5),
      ];
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

      final (restingHeartRatePoints, fastingWeightPoints) =
          service.createPointsOfCharts(
        chartRange: chartRange,
        startDate: startDate,
        endDate: endDate,
        measurements: measurements,
      );

      expect(restingHeartRatePoints, expectedRestingHeartRatePoints);
      expect(fastingWeightPoints, expectedFastingWeightPoints);
    },
  );

  test(
    'create points of charts, '
    'month range, '
    'should create points of all days from start date to end date',
    () {
      const ChartRange chartRange = ChartRange.month;
      final DateTime startDate = DateTime(2023, 5, 8);
      final DateTime endDate = DateTime(2023, 5, 12);
      final List<HealthMeasurement> measurements = [
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
      final List<HealthChartPoint> expectedRestingHeartRatePoints = [
        HealthChartPoint(date: startDate, value: null),
        HealthChartPoint(date: DateTime(2023, 5, 9), value: 51),
        HealthChartPoint(date: DateTime(2023, 5, 10), value: 53),
        HealthChartPoint(date: DateTime(2023, 5, 11), value: null),
        HealthChartPoint(date: endDate, value: 52),
      ];
      final List<HealthChartPoint> expectedFastingWeightPoints = [
        HealthChartPoint(date: startDate, value: null),
        HealthChartPoint(date: DateTime(2023, 5, 9), value: 60.5),
        HealthChartPoint(date: DateTime(2023, 5, 10), value: 64.0),
        HealthChartPoint(date: DateTime(2023, 5, 11), value: null),
        HealthChartPoint(date: endDate, value: 62.5),
      ];
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

      final (restingHeartRatePoints, fastingWeightPoints) =
          service.createPointsOfCharts(
        chartRange: chartRange,
        startDate: startDate,
        endDate: endDate,
        measurements: measurements,
      );

      expect(restingHeartRatePoints, expectedRestingHeartRatePoints);
      expect(fastingWeightPoints, expectedFastingWeightPoints);
    },
  );

  test(
    'create points of charts, '
    'year range, '
    'should create points for each month from start date to end date with calculated average values',
    () {
      const ChartRange chartRange = ChartRange.year;
      final DateTime startDate = DateTime(2023, 3, 8);
      final DateTime endDate = DateTime(2023, 6, 12);
      final List<HealthMeasurement> measurements = [
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
      final List<HealthChartPoint> expectedRestingHeartRatePoints = [
        HealthChartPoint(date: DateTime(2023, 3), value: null),
        HealthChartPoint(date: DateTime(2023, 4), value: (49 + 51 + 50) / 3),
        HealthChartPoint(date: DateTime(2023, 5), value: (51 + 53 + 52) / 3),
        HealthChartPoint(date: DateTime(2023, 6), value: null),
      ];
      final List<HealthChartPoint> expectedFastingWeightPoints = [
        HealthChartPoint(date: DateTime(2023, 3), value: null),
        HealthChartPoint(
          date: DateTime(2023, 4),
          value: (58.5 + 62 + 60.5) / 3,
        ),
        HealthChartPoint(
          date: DateTime(2023, 5),
          value: (60.5 + 64 + 62.5) / 3,
        ),
        HealthChartPoint(date: DateTime(2023, 6), value: null),
      ];

      final (restingHeartRatePoints, fastingWeightPoints) =
          service.createPointsOfCharts(
        chartRange: chartRange,
        startDate: startDate,
        endDate: endDate,
        measurements: measurements,
      );

      expect(restingHeartRatePoints, expectedRestingHeartRatePoints);
      expect(fastingWeightPoints, expectedFastingWeightPoints);
    },
  );

  test(
    'compute new range, '
    'week range, '
    'should return first and last days of current week',
    () {
      const ChartRange chartRange = ChartRange.week;
      final DateTime today = DateTime(2023, 5, 12);
      final DateTime firstDayOfTheWeek = DateTime(2023, 5, 8);
      final DateTime lastDayOfTheWeek = DateTime(2023, 5, 14);
      dateService.mockGetToday(todayDate: today);
      dateService.mockGetFirstDayOfTheWeek(date: firstDayOfTheWeek);
      dateService.mockGetLastDayOfTheWeek(date: lastDayOfTheWeek);

      final (startDate, endDate) = service.computeNewRange(
        chartRange: chartRange,
      );

      expect(startDate, firstDayOfTheWeek);
      expect(endDate, lastDayOfTheWeek);
    },
  );

  test(
    'compute new range, '
    'month range, '
    'should return first and last days of current month',
    () {
      const ChartRange chartRange = ChartRange.month;
      final DateTime today = DateTime(2023, 5, 12);
      final DateTime firstDayOfTheMonth = DateTime(2023, 5, 1);
      final DateTime lastDayOfTheMonth = DateTime(2023, 5, 31);
      dateService.mockGetToday(todayDate: today);
      dateService.mockGetFirstDayOfTheMonth(date: firstDayOfTheMonth);
      dateService.mockGetLastDayOfTheMonth(date: lastDayOfTheMonth);

      final (startDate, endDate) = service.computeNewRange(
        chartRange: chartRange,
      );

      expect(startDate, firstDayOfTheMonth);
      expect(endDate, lastDayOfTheMonth);
    },
  );

  test(
    'compute new range, '
    'year range, '
    'should return first and last days of current year',
    () {
      const ChartRange chartRange = ChartRange.year;
      final DateTime today = DateTime(2023, 5, 12);
      final DateTime firstDayOfTheYear = DateTime(2023, 1, 1);
      final DateTime lastDayOfTheYear = DateTime(2023, 12, 31);
      dateService.mockGetToday(todayDate: today);

      final (startDate, endDate) = service.computeNewRange(
        chartRange: chartRange,
      );

      expect(startDate, firstDayOfTheYear);
      expect(endDate, lastDayOfTheYear);
    },
  );

  test(
    'compute previous range, '
    'week range, '
    'should return first and last days of previous week',
    () {
      const ChartRange chartRange = ChartRange.week;
      final DateTime firstDayOfCurrentWeek = DateTime(2023, 5, 8);
      final DateTime lastDayOfCurrentWeek = DateTime(2023, 5, 14);
      final DateTime firstDayOfPreviousWeek = DateTime(2023, 5, 1);
      final DateTime lastDayOfPreviousWeek = DateTime(2023, 5, 7);

      final (startDate, endDate) = service.computePreviousRange(
        startDate: firstDayOfCurrentWeek,
        endDate: lastDayOfCurrentWeek,
        chartRange: chartRange,
      );

      expect(startDate, firstDayOfPreviousWeek);
      expect(endDate, lastDayOfPreviousWeek);
    },
  );

  test(
    'compute previous range, '
    'month range, '
    'should return first and last days of previous month',
    () {
      const ChartRange chartRange = ChartRange.month;
      final DateTime firstDayOfCurrentMonth = DateTime(2023, 5, 1);
      final DateTime lastDayOfCurrentMonth = DateTime(2023, 5, 31);
      final DateTime firstDayOfPreviousMonth = DateTime(2023, 4, 1);
      final DateTime lastDayOfPreviousMonth = DateTime(2023, 4, 30);

      final (startDate, endDate) = service.computePreviousRange(
        startDate: firstDayOfCurrentMonth,
        endDate: lastDayOfCurrentMonth,
        chartRange: chartRange,
      );

      expect(startDate, firstDayOfPreviousMonth);
      expect(endDate, lastDayOfPreviousMonth);
    },
  );

  test(
    'compute previous range, '
    'year range, '
    'should return first and last days of previous year',
    () {
      const ChartRange chartRange = ChartRange.year;
      final DateTime firstDayOfCurrentYear = DateTime(2023);
      final DateTime lastDayOfCurrentYear = DateTime(2023, 12, 31);
      final DateTime firstDayOfPreviousYear = DateTime(2022);
      final DateTime lastDayOfPreviousYear = DateTime(2022, 12, 31);

      final (startDate, endDate) = service.computePreviousRange(
        startDate: firstDayOfCurrentYear,
        endDate: lastDayOfCurrentYear,
        chartRange: chartRange,
      );

      expect(startDate, firstDayOfPreviousYear);
      expect(endDate, lastDayOfPreviousYear);
    },
  );

  test(
    'compute next range, '
    'week range, '
    'should return first and last days of next week',
    () {
      const ChartRange chartRange = ChartRange.week;
      final DateTime firstDayOfCurrentWeek = DateTime(2023, 5, 8);
      final DateTime lastDayOfCurrentWeek = DateTime(2023, 5, 14);
      final DateTime firstDayOfNextWeek = DateTime(2023, 5, 15);
      final DateTime lastDayOfNextWeek = DateTime(2023, 5, 21);

      final (startDate, endDate) = service.computeNextRange(
        startDate: firstDayOfCurrentWeek,
        endDate: lastDayOfCurrentWeek,
        chartRange: chartRange,
      );

      expect(startDate, firstDayOfNextWeek);
      expect(endDate, lastDayOfNextWeek);
    },
  );

  test(
    'compute next range, '
    'month range, '
    'should return first and last days of next month',
    () {
      const ChartRange chartRange = ChartRange.month;
      final DateTime firstDayOfCurrentMonth = DateTime(2023, 5);
      final DateTime lastDayOfCurrentMonth = DateTime(2023, 5, 31);
      final DateTime firstDayOfNextMonth = DateTime(2023, 6);
      final DateTime lastDayOfNextMonth = DateTime(2023, 6, 30);

      final (startDate, endDate) = service.computeNextRange(
        startDate: firstDayOfCurrentMonth,
        endDate: lastDayOfCurrentMonth,
        chartRange: chartRange,
      );

      expect(startDate, firstDayOfNextMonth);
      expect(endDate, lastDayOfNextMonth);
    },
  );

  test(
    'compute next range, '
    'year range, '
    'should return first and last days of next year',
    () {
      const ChartRange chartRange = ChartRange.year;
      final DateTime firstDayOfCurrentYear = DateTime(2023);
      final DateTime lastDayOfCurrentYear = DateTime(2023, 12, 31);
      final DateTime firstDayOfNextYear = DateTime(2024);
      final DateTime lastDayOfNextYear = DateTime(2024, 12, 31);

      final (startDate, endDate) = service.computeNextRange(
        startDate: firstDayOfCurrentYear,
        endDate: lastDayOfCurrentYear,
        chartRange: chartRange,
      );

      expect(startDate, firstDayOfNextYear);
      expect(endDate, lastDayOfNextYear);
    },
  );
}
