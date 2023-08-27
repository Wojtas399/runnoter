import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../domain/bloc/health_stats/health_stats_bloc.dart';
import '../../../domain/cubit/chart_date_range_cubit.dart';
import '../../component/date_range_header_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/text/label_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../formatter/date_formatter.dart';
import '../../service/utils.dart';

class HealthCharts extends StatelessWidget {
  const HealthCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleMedium(Str.of(context).healthSummaryOfMeasurements),
          const Gap16(),
          const _ChartRangeSelection(),
          const Gap8(),
          const _Charts(),
        ],
      ),
    );
  }
}

class _ChartRangeSelection extends StatelessWidget {
  const _ChartRangeSelection();

  @override
  Widget build(BuildContext context) {
    final DateRangeType? dateRangeType = context.select(
      (HealthStatsBloc bloc) => bloc.state.dateRangeType,
    );
    final DateRange? dateRange = context.select(
      (HealthStatsBloc bloc) => bloc.state.dateRange,
    );
    return dateRangeType != null && dateRange != null
        ? DateRangeHeader(
            selectedDateRangeType: dateRangeType,
            dateRange: dateRange,
            onWeekSelected: () =>
                _changeDateRangeType(context, DateRangeType.week),
            onMonthSelected: () =>
                _changeDateRangeType(context, DateRangeType.month),
            onYearSelected: () =>
                _changeDateRangeType(context, DateRangeType.year),
            onPreviousRangePressed: () => _previousDateRange(context),
            onNextRangePressed: () => _nextDateRange(context),
          )
        : const SizedBox();
  }

  void _changeDateRangeType(BuildContext context, DateRangeType dateRangeType) {
    context.read<HealthStatsBloc>().add(
          HealthStatsEventChangeChartDateRangeType(
            dateRangeType: dateRangeType,
          ),
        );
  }

  void _previousDateRange(BuildContext context) {
    context.read<HealthStatsBloc>().add(
          const HealthStatsEventPreviousChartDateRange(),
        );
  }

  void _nextDateRange(BuildContext context) {
    context.read<HealthStatsBloc>().add(
          const HealthStatsEventNextChartDateRange(),
        );
  }
}

class _Charts extends StatelessWidget {
  const _Charts();

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
    final List<HealthStatsChartPoint>? points = context.select(
      (HealthStatsBloc bloc) => bloc.state.restingHeartRatePoints,
    );

    return points != null ? _LineChart(points: points) : const SizedBox();
  }
}

class _FastingWeightChart extends StatelessWidget {
  const _FastingWeightChart();

  @override
  Widget build(BuildContext context) {
    final List<HealthStatsChartPoint>? points = context.select(
      (HealthStatsBloc bloc) => bloc.state.fastingWeightPoints,
    );

    return points != null ? _LineChart(points: points) : const SizedBox();
  }
}

class _LineChart extends StatelessWidget {
  final List<HealthStatsChartPoint> points;

  const _LineChart({required this.points});

  @override
  Widget build(BuildContext context) {
    final DateRangeType? dateRangeType = context.select(
      (HealthStatsBloc bloc) => bloc.state.dateRangeType,
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
            series: <LineSeries<HealthStatsChartPoint, String>>[
              LineSeries<HealthStatsChartPoint, String>(
                dataSource: points,
                xValueMapper: (HealthStatsChartPoint point, _) =>
                    _mapDateToLabel(context, point.date, dateRangeType),
                yValueMapper: (HealthStatsChartPoint point, _) => point.value,
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
