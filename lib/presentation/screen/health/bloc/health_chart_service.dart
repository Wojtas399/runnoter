import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/model/health_measurement.dart';

class HealthChartService {
  final DateService _dateService;

  const HealthChartService({
    required DateService dateService,
  }) : _dateService = dateService;

  (List<HealthChartPoint>, List<HealthChartPoint>) createPointsOfCharts({
    required ChartRange chartRange,
    required DateTime startDate,
    required DateTime endDate,
    required List<HealthMeasurement> measurements,
  }) {
    if (chartRange == ChartRange.year) {
      return _createPointsForEachMonth(startDate, endDate, measurements);
    } else {
      return _createPointsForEachDay(startDate, endDate, measurements);
    }
  }

  (DateTime, DateTime) computeNewRange({
    required ChartRange chartRange,
  }) {
    final DateTime today = _dateService.getToday();
    return switch (chartRange) {
      ChartRange.week => (
          _dateService.getFirstDayOfTheWeek(today),
          _dateService.getLastDayOfTheWeek(today),
        ),
      ChartRange.month => (
          _dateService.getFirstDayOfTheMonth(today.month, today.year),
          _dateService.getLastDayOfTheMonth(today.month, today.year),
        ),
      ChartRange.year => (
          DateTime(today.year),
          DateTime(today.year, 12, 31),
        ),
    };
  }

  (DateTime, DateTime) computePreviousRange({
    required DateTime startDate,
    required DateTime endDate,
    required ChartRange chartRange,
  }) =>
      switch (chartRange) {
        ChartRange.week => (
            startDate.subtract(const Duration(days: 7)),
            endDate.subtract(const Duration(days: 7)),
          ),
        ChartRange.month => (
            DateTime(startDate.year, startDate.month - 1),
            DateTime(startDate.year, startDate.month).subtract(
              const Duration(days: 1),
            ),
          ),
        ChartRange.year => (
            DateTime(startDate.year - 1),
            DateTime(startDate.year - 1, 12, 31),
          ),
      };

  (DateTime, DateTime) computeNextRange({
    required DateTime startDate,
    required DateTime endDate,
    required ChartRange chartRange,
  }) =>
      switch (chartRange) {
        ChartRange.week => (
            startDate.add(const Duration(days: 7)),
            endDate.add(const Duration(days: 7)),
          ),
        ChartRange.month => (
            DateTime(startDate.year, startDate.month + 1),
            DateTime(startDate.year, startDate.month + 2).subtract(
              const Duration(days: 1),
            ),
          ),
        ChartRange.year => (
            DateTime(startDate.year + 1),
            DateTime(startDate.year + 1, 12, 31),
          ),
      };

  (List<HealthChartPoint>, List<HealthChartPoint>) _createPointsForEachDay(
    DateTime startDate,
    DateTime endDate,
    List<HealthMeasurement> measurements,
  ) {
    DateTime counterDate = startDate;
    final DateTime dayAfterEndDay = endDate.add(const Duration(days: 1));
    final List<HealthChartPoint> restingHeartRatePoints = [];
    final List<HealthChartPoint> fastingWeightPoints = [];
    while (!_dateService.areDatesTheSame(counterDate, dayAfterEndDay)) {
      final measurementIndex = measurements.indexWhere(
        (measurement) => _dateService.areDatesTheSame(
          measurement.date,
          counterDate,
        ),
      );
      int? restingHeartRate;
      double? fastingWeight;
      if (measurementIndex >= 0) {
        restingHeartRate = measurements[measurementIndex].restingHeartRate;
        fastingWeight = measurements[measurementIndex].fastingWeight;
      }
      restingHeartRatePoints.add(
        HealthChartPoint(date: counterDate, value: restingHeartRate),
      );
      fastingWeightPoints.add(
        HealthChartPoint(date: counterDate, value: fastingWeight),
      );
      counterDate = counterDate.add(const Duration(days: 1));
    }
    return (restingHeartRatePoints, fastingWeightPoints);
  }

  (List<HealthChartPoint>, List<HealthChartPoint>) _createPointsForEachMonth(
    DateTime startDate,
    DateTime endDate,
    List<HealthMeasurement> measurements,
  ) {
    DateTime counterDate = DateTime(startDate.year, startDate.month);
    final List<HealthChartPoint> restingHeartRatePoints = [];
    final List<HealthChartPoint> fastingWeightPoints = [];
    while (counterDate.year <= endDate.year &&
        counterDate.month <= endDate.month) {
      final measurementsFromMonth = measurements.where(
        (mes) =>
            mes.date.year == counterDate.year &&
            mes.date.month == counterDate.month,
      );
      double? avgRestingHeartRate, avgFastingWeight;
      if (measurementsFromMonth.isNotEmpty) {
        avgRestingHeartRate = measurementsFromMonth
            .map((measurement) => measurement.restingHeartRate)
            .average;
        avgFastingWeight = measurementsFromMonth
            .map((measurement) => measurement.fastingWeight)
            .average;
      }
      restingHeartRatePoints.add(
        HealthChartPoint(date: counterDate, value: avgRestingHeartRate),
      );
      fastingWeightPoints.add(
        HealthChartPoint(date: counterDate, value: avgFastingWeight),
      );
      counterDate = DateTime(counterDate.year, counterDate.month + 1);
    }
    return (restingHeartRatePoints, fastingWeightPoints);
  }
}

class HealthChartPoint extends Equatable {
  final DateTime date;
  final num? value;

  const HealthChartPoint({
    required this.date,
    required this.value,
  });

  @override
  List<Object?> get props => [
        date,
        value,
      ];
}

enum ChartRange {
  week,
  month,
  year,
}
