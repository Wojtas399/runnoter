import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../domain/bloc/health/health_bloc.dart';
import '../../../domain/cubit/chart_date_range_cubit.dart';
import '../../component/gap/gap_components.dart';
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
        LabelLarge(str.restingHeartRate),
        const Gap8(),
        const _RestingHeartRateChart(),
        const Gap16(),
        LabelLarge(str.fastingWeight),
        const Gap8(),
        const _FastingWeightChart(),
      ],
    );
  }
}

class _RestingHeartRateChart extends StatelessWidget {
  const _RestingHeartRateChart();

  @override
  Widget build(BuildContext context) {
    final List<HealthChartPoint>? points = context.select(
      (HealthBloc bloc) => bloc.state.restingHeartRatePoints,
    );

    return points != null ? _LineChart(points: points) : const SizedBox();
  }
}

class _FastingWeightChart extends StatelessWidget {
  const _FastingWeightChart();

  @override
  Widget build(BuildContext context) {
    final List<HealthChartPoint>? points = context.select(
      (HealthBloc bloc) => bloc.state.fastingWeightPoints,
    );

    return points != null ? _LineChart(points: points) : const SizedBox();
  }
}

class _LineChart extends StatelessWidget {
  final List<HealthChartPoint> points;

  const _LineChart({required this.points});

  @override
  Widget build(BuildContext context) {
    final DateRangeType? dateRangeType = context.select(
      (HealthBloc bloc) => bloc.state.dateRangeType,
    );

    return dateRangeType == null
        ? const CircularProgressIndicator()
        : SfCartesianChart(
            primaryXAxis: CategoryAxis(
              interval: switch (dateRangeType) {
                DateRangeType.week => 1,
                DateRangeType.month => 7,
                DateRangeType.year => 1,
              },
            ),
            series: <LineSeries<HealthChartPoint, String>>[
              LineSeries<HealthChartPoint, String>(
                dataSource: points,
                xValueMapper: (HealthChartPoint point, _) =>
                    _mapDateToLabel(context, point.date, dateRangeType),
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
    DateRangeType dateRangeType,
  ) =>
      switch (dateRangeType) {
        DateRangeType.week => date.toDayAbbreviation(context),
        DateRangeType.month =>
          '${twoDigits(date.day)}.${twoDigits(date.month)}',
        DateRangeType.year => date.toMonthAbbreviation(context),
      };
}
