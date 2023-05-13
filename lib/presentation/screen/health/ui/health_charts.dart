part of 'health_screen.dart';

class _Charts extends StatelessWidget {
  const _Charts();

  @override
  Widget build(BuildContext context) {
    final ChartRange chartRange = context.select(
      (HealthBloc bloc) => bloc.state.chartRange,
    );
    final List<HealthChartPoint>? chartPoints = context.select(
      (HealthBloc bloc) => bloc.state.chartPoints,
    );

    if (chartPoints == null) {
      return const SizedBox();
    }

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <LineSeries<HealthChartPoint, String>>[
        LineSeries<HealthChartPoint, String>(
          dataSource: chartPoints,
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
