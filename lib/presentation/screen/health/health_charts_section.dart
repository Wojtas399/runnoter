import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/health/health_bloc.dart';
import '../../../domain/service/health_chart_service.dart';
import '../../component/text/title_text_components.dart';
import '../../formatter/date_formatter.dart';
import 'health_charts.dart';

class HealthChartsSection extends StatelessWidget {
  const HealthChartsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TitleMedium(Str.of(context).healthSummaryOfMeasurements),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: _ChartRangeSelection(),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 24),
            child: HealthCharts(),
          ),
        ],
      ),
    );
  }
}

class _ChartRangeSelection extends StatelessWidget {
  const _ChartRangeSelection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: const _ChartRangeType(),
        ),
        const SizedBox(height: 8),
        const _ChartRange(),
      ],
    );
  }
}

class _ChartRangeType extends StatelessWidget {
  const _ChartRangeType();

  @override
  Widget build(BuildContext context) {
    final ChartRange chartRange = context.select(
      (HealthBloc bloc) => bloc.state.chartRange,
    );
    const Widget gap = SizedBox(width: 16);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ChartRangeTypeButton(
          label: Str.of(context).healthChartRangeWeek,
          isSelected: chartRange == ChartRange.week,
          onPressed: () {
            _onButtonPressed(context, ChartRange.week);
          },
        ),
        gap,
        _ChartRangeTypeButton(
          label: Str.of(context).healthChartRangeMonth,
          isSelected: chartRange == ChartRange.month,
          onPressed: () {
            _onButtonPressed(context, ChartRange.month);
          },
        ),
        gap,
        _ChartRangeTypeButton(
          label: Str.of(context).healthChartRangeYear,
          isSelected: chartRange == ChartRange.year,
          onPressed: () {
            _onButtonPressed(context, ChartRange.year);
          },
        ),
      ],
    );
  }

  void _onButtonPressed(BuildContext context, ChartRange chartRange) {
    context.read<HealthBloc>().add(
          HealthEventChangeChartRangeType(chartRangeType: chartRange),
        );
  }
}

class _ChartRange extends StatelessWidget {
  const _ChartRange();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _PreviousRangeButton(),
          _CurrentRangeLabel(),
          _NextRangeButton(),
        ],
      ),
    );
  }
}

class _ChartRangeTypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ChartRangeTypeButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isSelected
          ? FilledButton(
              onPressed: onPressed,
              child: Text(label),
            )
          : OutlinedButton(
              onPressed: onPressed,
              child: Text(label),
            ),
    );
  }
}

class _PreviousRangeButton extends StatelessWidget {
  const _PreviousRangeButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _onPressed(context);
      },
      icon: const Icon(Icons.chevron_left),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<HealthBloc>().add(
          const HealthEventPreviousChartRange(),
        );
  }
}

class _CurrentRangeLabel extends StatelessWidget {
  const _CurrentRangeLabel();

  @override
  Widget build(BuildContext context) {
    final List<HealthChartPoint>? chartPoints = context.select(
      (HealthBloc bloc) => bloc.state.restingHeartRatePoints,
    );

    if (chartPoints == null) {
      return const SizedBox();
    }

    final DateTime startDate = chartPoints.first.date;
    final DateTime endDate = chartPoints.last.date;
    final ChartRange chartRange = context.select(
      (HealthBloc bloc) => bloc.state.chartRange,
    );

    return TitleMedium(
      _createLabel(context, startDate, endDate, chartRange),
    );
  }

  String _createLabel(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
    ChartRange chartRange,
  ) =>
      switch (chartRange) {
        ChartRange.week =>
          '${startDate.toDateWithDots()} - ${endDate.toDateWithDots()}',
        ChartRange.month =>
          '${startDate.toMonthName(context)} ${startDate.year}',
        ChartRange.year => '${startDate.year}',
      };
}

class _NextRangeButton extends StatelessWidget {
  const _NextRangeButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _onPressed(context);
      },
      icon: const Icon(Icons.chevron_right),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<HealthBloc>().add(
          const HealthEventNextChartRange(),
        );
  }
}
