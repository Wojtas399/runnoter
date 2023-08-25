import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/health/health_bloc.dart';
import '../../../domain/cubit/chart_date_range_cubit.dart';
import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
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
          TitleMedium(Str.of(context).healthSummaryOfMeasurements),
          const Gap16(),
          const _ChartRangeSelection(),
          const Gap8(),
          const HealthCharts(),
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
        const Gap8(),
        const _ChartRange(),
      ],
    );
  }
}

class _ChartRangeType extends StatelessWidget {
  const _ChartRangeType();

  @override
  Widget build(BuildContext context) {
    final DateRangeType? dateRangeType = context.select(
      (HealthBloc bloc) => bloc.state.dateRangeType,
    );
    const Widget gap = GapHorizontal16();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ChartRangeTypeButton(
          label: Str.of(context).healthChartRangeWeek,
          isSelected: dateRangeType == DateRangeType.week,
          onPressed: () => _onPressed(context, DateRangeType.week),
        ),
        gap,
        _ChartRangeTypeButton(
          label: Str.of(context).healthChartRangeMonth,
          isSelected: dateRangeType == DateRangeType.month,
          onPressed: () => _onPressed(context, DateRangeType.month),
        ),
        gap,
        _ChartRangeTypeButton(
          label: Str.of(context).healthChartRangeYear,
          isSelected: dateRangeType == DateRangeType.year,
          onPressed: () => _onPressed(context, DateRangeType.year),
        ),
      ],
    );
  }

  void _onPressed(BuildContext context, DateRangeType dateRangeType) {
    context.read<HealthBloc>().add(
          HealthEventChangeChartDateRangeType(dateRangeType: dateRangeType),
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
          const HealthEventPreviousChartDateRange(),
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

    if (chartPoints == null) return const SizedBox();

    final DateTime startDate = chartPoints.first.date;
    final DateTime endDate = chartPoints.last.date;
    final DateRangeType? dateRangeType = context.select(
      (HealthBloc bloc) => bloc.state.dateRangeType,
    );

    return dateRangeType == null
        ? const SizedBox()
        : TitleMedium(
            _createLabel(context, startDate, endDate, dateRangeType),
          );
  }

  String _createLabel(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
    DateRangeType dateRangeType,
  ) =>
      switch (dateRangeType) {
        DateRangeType.week =>
          '${startDate.toDateWithDots()} - ${endDate.toDateWithDots()}',
        DateRangeType.month =>
          '${startDate.toMonthName(context)} ${startDate.year}',
        DateRangeType.year => '${startDate.year}',
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
          const HealthEventNextChartDateRange(),
        );
  }
}
