import 'package:mocktail/mocktail.dart';
import 'package:runnoter/presentation/screen/health/bloc/health_chart_service.dart';

class MockHealthChartService extends Mock implements HealthChartService {
  void mockCreatePointsOfCharts({
    required (List<HealthChartPoint>, List<HealthChartPoint>) points,
  }) {
    when(
      () => createPointsOfCharts(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
          measurements: any(
            named: 'measurements',
          )),
    ).thenReturn(points);
  }

  void mockComputeNewRange({
    required (DateTime, DateTime) range,
  }) {
    _mockChartRange();
    when(
      () => computeNewRange(
        chartRange: any(named: 'chartRange'),
      ),
    ).thenReturn(range);
  }

  void mockComputePreviousRange({
    required (DateTime, DateTime) previousRange,
  }) {
    when(
      () => computePreviousRange(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        chartRange: any(named: 'chartRange'),
      ),
    ).thenReturn(
      previousRange,
    );
  }

  void mockComputeNextRange({
    required (DateTime, DateTime) nextRange,
  }) {
    when(
      () => computeNextRange(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        chartRange: any(named: 'chartRange'),
      ),
    ).thenReturn(nextRange);
  }

  void _mockChartRange() {
    registerFallbackValue(ChartRange.week);
  }
}
