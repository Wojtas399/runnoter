part of 'health_screen.dart';

class _ChartRangeSelection extends StatelessWidget {
  const _ChartRangeSelection();

  @override
  Widget build(BuildContext context) {
    final ChartRange chartRange = context.select(
      (HealthBloc bloc) => bloc.state.chartRange,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ChartRangeButton(
          label: Str.of(context).healthChartRangeWeek,
          isSelected: chartRange == ChartRange.week,
          onPressed: () {
            _onButtonPressed(context, ChartRange.week);
          },
        ),
        const SizedBox(width: 16),
        _ChartRangeButton(
          label: Str.of(context).healthChartRangeMonth,
          isSelected: chartRange == ChartRange.month,
          onPressed: () {
            _onButtonPressed(context, ChartRange.month);
          },
        ),
        const SizedBox(width: 16),
        _ChartRangeButton(
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
          HealthEventChangeChartRange(newChartRange: chartRange),
        );
  }
}

class _ChartRangeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ChartRangeButton({
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
