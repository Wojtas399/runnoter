import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../component/date_range_header_component.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/loading_info_component.dart';
import '../../../component/text/label_text_components.dart';
import '../../../component/text/title_text_components.dart';
import '../../../cubit/date_range_manager_cubit.dart';
import '../../../cubit/health_stats/health_stats_cubit.dart';
import '../../../extension/context_extensions.dart';
import '../../../formatter/date_formatter.dart';

class ClientStatsHealth extends StatelessWidget {
  const ClientStatsHealth({super.key});

  @override
  Widget build(BuildContext context) {
    final String label = Str.of(context).clientStatsHealthMeasurements;

    return Column(
      children: [
        Row(
          children: [
            if (context.isMobileSize) TitleMedium(label) else TitleLarge(label),
          ],
        ),
        const Gap24(),
        BlocBuilder<HealthStatsCubit, HealthStatsState>(
          builder: (BuildContext context, HealthStatsState state) {
            if (state.dateRangeType == null ||
                state.dateRange == null ||
                state.restingHeartRatePoints == null ||
                state.fastingWeightPoints == null) {
              return const LoadingInfo();
            }
            return const Column(
              children: [_DateRange(), Gap16(), _Charts()],
            );
          },
        ),
      ],
    );
  }
}

class _DateRange extends StatelessWidget {
  const _DateRange();

  @override
  Widget build(BuildContext context) {
    final DateRangeType dateRangeType = context.select(
      (HealthStatsCubit cubit) => cubit.state.dateRangeType!,
    );
    final DateRange dateRange = context.select(
      (HealthStatsCubit cubit) => cubit.state.dateRange!,
    );
    final HealthStatsCubit healthStatsCubit = context.read<HealthStatsCubit>();

    return DateRangeHeader(
      selectedDateRangeType: dateRangeType,
      dateRange: dateRange,
      onWeekSelected: () =>
          healthStatsCubit.changeChartDateRangeType(DateRangeType.week),
      onMonthSelected: () =>
          healthStatsCubit.changeChartDateRangeType(DateRangeType.month),
      onYearSelected: () =>
          healthStatsCubit.changeChartDateRangeType(DateRangeType.year),
      onPreviousRangePressed: healthStatsCubit.previousChartDateRange,
      onNextRangePressed: healthStatsCubit.nextChartDateRange,
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
    final List<HealthStatsChartPoint> points = context.select(
      (HealthStatsCubit cubit) => cubit.state.restingHeartRatePoints!,
    );

    return _LineChart(
      yAxisLabel:
          '${Str.of(context).restingHeartRate} [${Str.of(context).heartRateUnit}]',
      points: points,
    );
  }
}

class _FastingWeightChart extends StatelessWidget {
  const _FastingWeightChart();

  @override
  Widget build(BuildContext context) {
    final List<HealthStatsChartPoint> points = context.select(
      (HealthStatsCubit cubit) => cubit.state.fastingWeightPoints!,
    );

    return _LineChart(
      yAxisLabel: '${Str.of(context).fastingWeight} [kg]',
      points: points,
    );
  }
}

class _LineChart extends StatelessWidget {
  final String yAxisLabel;
  final List<HealthStatsChartPoint> points;

  const _LineChart({required this.yAxisLabel, required this.points});

  @override
  Widget build(BuildContext context) {
    final String? languageCode = context.languageCode;
    final DateRangeType dateRangeType = context.select(
      (HealthStatsCubit cubit) => cubit.state.dateRangeType!,
    );

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        interval: switch (dateRangeType) {
          DateRangeType.week => 1,
          DateRangeType.month => 7,
          DateRangeType.year => 1,
        },
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: yAxisLabel,
          textStyle: Theme.of(context).textTheme.labelSmall,
        ),
      ),
      series: <LineSeries<HealthStatsChartPoint, String>>[
        LineSeries<HealthStatsChartPoint, String>(
          dataSource: points,
          xValueMapper: (HealthStatsChartPoint point, _) =>
              _mapDateToLabel(languageCode, point.date, dateRangeType),
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
    String? languageCode,
    DateTime date,
    DateRangeType dateRangeType,
  ) =>
      switch (dateRangeType) {
        DateRangeType.week => date.toDayAbbreviation(languageCode),
        DateRangeType.month => date.toDayWithMonth(),
        DateRangeType.year => date.toMonthAbbreviation(languageCode),
      };
}
