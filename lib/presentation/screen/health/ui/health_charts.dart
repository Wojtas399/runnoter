part of 'health_screen.dart';

class _Charts extends StatelessWidget {
  const _Charts();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          Str.of(context).healthRestingHeartRate,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        const _RestingHeartRateChart(),
      ],
    );
  }
}

class _RestingHeartRateChart extends StatelessWidget {
  const _RestingHeartRateChart();

  @override
  Widget build(BuildContext context) {
    final ChartRange chartRange = context.select(
      (HealthBloc bloc) => bloc.state.chartRange,
    );
    final List<HealthChartPoint>? points = context.select(
      (HealthBloc bloc) => bloc.state.chartPoints,
    );

    if (points != null) {
      return _LineChart(
        points: points,
        chartRange: chartRange,
      );
    }
    return const SizedBox();
  }
}

class _LineChart extends StatelessWidget {
  final List<HealthChartPoint> points;
  final ChartRange chartRange;

  const _LineChart({
    required this.points,
    required this.chartRange,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <LineSeries<HealthChartPoint, String>>[
        LineSeries<HealthChartPoint, String>(
          dataSource: points,
          xValueMapper: (HealthChartPoint point, _) =>
              _mapDateToLabel(context, point.date, chartRange),
          yValueMapper: (HealthChartPoint point, _) => point.value,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
          color: Theme.of(context).colorScheme.primary,
          markerSettings: MarkerSettings(
            isVisible: true,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  String _mapDateToLabel(
    BuildContext context,
    DateTime date,
    ChartRange chartRange,
  ) =>
      switch (chartRange) {
        ChartRange.week => date.toDayAbbreviation(context),
        ChartRange.month => '${twoDigits(date.day)}.${twoDigits(date.month)}',
        ChartRange.year => '${date.year}',
      };
}
