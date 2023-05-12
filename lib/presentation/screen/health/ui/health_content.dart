part of 'health_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _Section(
              label: Str.of(context).healthMorningMeasurement,
              child: const _ThisMorningMeasurement(),
            ),
            const SizedBox(height: 24),
            _Section(
              label: Str.of(context).healthSummaryOfMeasurements,
              child: const _ChartRangeSelection(),
            ),
            const SizedBox(height: 24),
            const _Charts(),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String label;
  final Widget child;

  const _Section({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}
