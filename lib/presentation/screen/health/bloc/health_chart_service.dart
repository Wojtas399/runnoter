import 'package:equatable/equatable.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/model/morning_measurement.dart';

class HealthChartService {
  final DateService _dateService;

  const HealthChartService({
    required DateService dateService,
  }) : _dateService = dateService;

  List<HealthChartPoint> createInitialChartPoints(
    DateTime startDate,
    DateTime endDate,
  ) {
    DateTime counterDate = startDate;
    final List<HealthChartPoint> chartPoints = [];
    while (!_dateService.areDatesTheSame(counterDate, endDate)) {
      chartPoints.add(
        HealthChartPoint(date: counterDate, value: null),
      );
      counterDate = counterDate.add(const Duration(days: 1));
    }
    chartPoints.add(
      HealthChartPoint(date: endDate, value: null),
    );
    return chartPoints;
  }

  List<HealthChartPoint> updateChartPointsWithRestingHeartRateMeasurements(
    List<HealthChartPoint>? chartPoints,
    List<MorningMeasurement> measurements,
  ) {
    final List<HealthChartPoint> updatedChartPoints = [...?chartPoints];
    for (final measurement in measurements) {
      final pointIndex = updatedChartPoints.indexWhere(
        (point) => _dateService.areDatesTheSame(point.date, measurement.date),
      );
      if (pointIndex >= 0) {
        updatedChartPoints[pointIndex] = HealthChartPoint(
          date: measurement.date,
          value: measurement.restingHeartRate,
        );
      }
    }
    return updatedChartPoints;
  }

  List<HealthChartPoint> updateChartPointsWithFastingWeightMeasurements(
    List<HealthChartPoint>? chartPoints,
    List<MorningMeasurement> measurements,
  ) {
    final List<HealthChartPoint> updatedChartPoints = [...?chartPoints];
    for (final measurement in measurements) {
      final pointIndex = updatedChartPoints.indexWhere(
        (point) => _dateService.areDatesTheSame(point.date, measurement.date),
      );
      if (pointIndex >= 0) {
        updatedChartPoints[pointIndex] = HealthChartPoint(
          date: measurement.date,
          value: measurement.fastingWeight,
        );
      }
    }
    return updatedChartPoints;
  }

  (DateTime, DateTime) computeNewRange(ChartRange chartRange) {
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

  (DateTime, DateTime) computePreviousRange(
    DateTime startDate,
    DateTime endDate,
    ChartRange chartRange,
  ) =>
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

  (DateTime, DateTime) computeNextRange(
    DateTime startDate,
    DateTime endDate,
    ChartRange chartRange,
  ) =>
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
