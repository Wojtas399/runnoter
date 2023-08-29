import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../domain/bloc/mileage_stats/mileage_stats_bloc.dart';
import '../../../domain/cubit/date_range_manager_cubit.dart';
import '../../component/body/big_body_component.dart';
import '../../component/card_body_component.dart';
import '../../component/date_range_header_component.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/distance_unit_formatter.dart';

class MileageContent extends StatelessWidget {
  const MileageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: Padding(
        padding: EdgeInsets.all(16),
        child: _CommonContent(),
      ),
      desktopBody: Column(
        children: [
          BigBody(
            child: Paddings24(
              child: CardBody(
                child: _CommonContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommonContent extends StatelessWidget {
  const _CommonContent();

  @override
  Widget build(BuildContext context) {
    final MileageStatsState state = context.watch<MileageStatsBloc>().state;
    if (state.dateRangeType == null ||
        state.dateRange == null ||
        state.mileageChartPoints == null) {
      return const LoadingInfo();
    } else if (state.mileageChartPoints!.isEmpty) {
      return const _NoDataInfo();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _DateRange(
            dateRangeType: state.dateRangeType!,
            dateRange: state.dateRange!,
          ),
        ),
        const Gap8(),
        _Chart(
          dateRangeType: state.dateRangeType!,
          chartPoints: state.mileageChartPoints!,
        ),
      ],
    );
  }
}

class _NoDataInfo extends StatelessWidget {
  const _NoDataInfo();

  @override
  Widget build(BuildContext context) {
    return Paddings24(
      child: EmptyContentInfo(
        icon: Icons.insert_chart_outlined,
        title: Str.of(context).mileageNoDataTitle,
        subtitle: Str.of(context).mileageNoDataMessage,
      ),
    );
  }
}

class _DateRange extends StatelessWidget {
  final DateRangeType dateRangeType;
  final DateRange dateRange;

  const _DateRange({required this.dateRangeType, required this.dateRange});

  @override
  Widget build(BuildContext context) {
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
  final DateRangeType dateRangeType;
  final List<MileageStatsChartPoint> chartPoints;

  const _Chart({required this.dateRangeType, required this.chartPoints});

  @override
  Widget build(BuildContext context) {
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
              _createXLabel(context, point),
          yValueMapper: (MileageStatsChartPoint point, _) =>
              context.convertDistanceFromDefaultUnit(point.mileage),
        ),
      ],
    );
  }

  String _createXLabel(BuildContext context, MileageStatsChartPoint point) =>
      switch (dateRangeType) {
        DateRangeType.week => point.date.toDayAbbreviation(context),
        DateRangeType.month => '',
        DateRangeType.year => point.date.toMonthAbbreviation(context),
      };
}
