import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../domain/bloc/mileage_stats/mileage_stats_bloc.dart';
import '../../../domain/cubit/chart_date_range_cubit.dart';
import '../../component/date_range_header_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/loading_info_component.dart';
import '../../component/text/title_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/distance_unit_formatter.dart';

class ClientStatsMileage extends StatelessWidget {
  const ClientStatsMileage({super.key});

  @override
  Widget build(BuildContext context) {
    final String label = Str.of(context).clientStatsMileage;

    return Column(
      children: [
        Row(
          children: [
            if (context.isMobileSize) TitleMedium(label) else TitleLarge(label),
          ],
        ),
        const Gap24(),
        BlocBuilder<MileageStatsBloc, MileageStatsState>(
          builder: (_, MileageStatsState state) {
            if (state.dateRangeType == null ||
                state.dateRange == null ||
                state.mileageChartPoints == null) {
              return const LoadingInfo();
            }
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [_DateRange(), Gap16(), _Chart()],
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
      (MileageStatsBloc bloc) => bloc.state.dateRangeType!,
    );
    final DateRange dateRange = context.select(
      (MileageStatsBloc bloc) => bloc.state.dateRange!,
    );

    return DateRangeHeader(
      selectedDateRangeType: dateRangeType,
      dateRange: dateRange,
      onWeekSelected: () => _changeDateRangeType(context, DateRangeType.week),
      onYearSelected: () => _changeDateRangeType(context, DateRangeType.year),
      onPreviousRangePressed: () => _onPreviousRangePressed(context),
      onNextRangePressed: () => _onNextRangePressed(context),
    );
  }

  void _changeDateRangeType(BuildContext context, DateRangeType dateRangeType) {
    context.read<MileageStatsBloc>().add(
          MileageStatsEventChangeDateRangeType(dateRangeType: dateRangeType),
        );
  }

  void _onPreviousRangePressed(BuildContext context) {
    context.read<MileageStatsBloc>().add(
          const MileageStatsEventPreviousDateRange(),
        );
  }

  void _onNextRangePressed(BuildContext context) {
    context.read<MileageStatsBloc>().add(
          const MileageStatsEventNextDateRange(),
        );
  }
}

class _Chart extends StatelessWidget {
  const _Chart();

  @override
  Widget build(BuildContext context) {
    final DateRangeType dateRangeType = context.select(
      (MileageStatsBloc bloc) => bloc.state.dateRangeType!,
    );
    final List<MileageStatsChartPoint> chartPoints = context.select(
      (MileageStatsBloc bloc) => bloc.state.mileageChartPoints!,
    );

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(interval: 1),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text:
              '${Str.of(context).mileageChartMileage} [${context.distanceUnit.toUIShortFormat()}]',
          textStyle: Theme.of(context).textTheme.labelSmall,
        ),
      ),
      series: <ColumnSeries<MileageStatsChartPoint, String>>[
        ColumnSeries(
          dataSource: chartPoints,
          xValueMapper: (MileageStatsChartPoint point, _) =>
              _createXLabel(context, dateRangeType, point),
          yValueMapper: (MileageStatsChartPoint point, _) =>
              context.convertDistanceFromDefaultUnit(point.mileage),
        ),
      ],
    );
  }

  String _createXLabel(
    BuildContext context,
    DateRangeType dateRangeType,
    MileageStatsChartPoint point,
  ) =>
      switch (dateRangeType) {
        DateRangeType.week => point.date.toDayAbbreviation(context),
        DateRangeType.month => '',
        DateRangeType.year => point.date.toMonthAbbreviation(context),
      };
}
