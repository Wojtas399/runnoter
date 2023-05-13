part of 'health_screen.dart';

class _ChartRangeSelection extends StatelessWidget {
  const _ChartRangeSelection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _ChartRangeType(),
        SizedBox(height: 16),
        _ChartRange(),
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
        const SizedBox(width: 16),
        _ChartRangeTypeButton(
          label: Str.of(context).healthChartRangeMonth,
          isSelected: chartRange == ChartRange.month,
          onPressed: () {
            _onButtonPressed(context, ChartRange.month);
          },
        ),
        const SizedBox(width: 16),
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
      (HealthBloc bloc) => bloc.state.chartPoints,
    );

    if (chartPoints == null) {
      return const SizedBox();
    }

    final DateTime startDate = chartPoints.first.date;
    final DateTime endDate = chartPoints.last.date;
    final ChartRange chartRange = context.select(
      (HealthBloc bloc) => bloc.state.chartRange,
    );

    return Text(
      _createLabel(context, startDate, endDate, chartRange),
      style: Theme.of(context).textTheme.titleMedium,
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
