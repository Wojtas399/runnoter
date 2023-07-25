import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../domain/bloc/health/health_bloc.dart';
import '../../../domain/service/health_chart_service.dart';
import '../../component/text/label_text_components.dart';
import '../../formatter/date_formatter.dart';
import '../../service/utils.dart';

class HealthCharts extends StatelessWidget {
  const HealthCharts({super.key});

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    return Column(
      children: [
        LabelLarge(str.healthRestingHeartRate),
        const SizedBox(height: 8),
        const _RestingHeartRateChart(),
        const SizedBox(height: 16),
        LabelLarge(str.healthFastingWeight),
        const SizedBox(height: 8),
        const _FastingWeightChart(),
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
      (HealthBloc bloc) => bloc.state.restingHeartRatePoints,
    );

    return points != null
        ? _LineChart(points: points, chartRange: chartRange)
        : const SizedBox();
  }
}

class _FastingWeightChart extends StatelessWidget {
  const _FastingWeightChart();

  @override
  Widget build(BuildContext context) {
    final ChartRange chartRange = context.select(
      (HealthBloc bloc) => bloc.state.chartRange,
    );
    final List<HealthChartPoint>? points = context.select(
      (HealthBloc bloc) => bloc.state.fastingWeightPoints,
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
      primaryXAxis: CategoryAxis(
        interval: switch (chartRange) {
          ChartRange.week => 1,
          ChartRange.month => 7,
          ChartRange.year => 1,
        },
      ),
      series: <LineSeries<HealthChartPoint, String>>[
        LineSeries<HealthChartPoint, String>(
          dataSource: points,
          xValueMapper: (HealthChartPoint point, _) =>
              _mapDateToLabel(context, point.date, chartRange),
          yValueMapper: (HealthChartPoint point, _) => point.value,
          color: Theme.of(context).colorScheme.primary,
          markerSettings: MarkerSettings(
            isVisible: true,
            color: Theme.of(context).colorScheme.primary,
            borderColor: Theme.of(context).colorScheme.primary,
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
        ChartRange.year => date.toMonthAbbreviation(context),
      };
}
