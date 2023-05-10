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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Str.of(context).healthMorningMeasurement,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 16),
                const _ThisMorningMeasurement(),
              ],
            ),
            const SizedBox(height: 24),
            const _ChartRangeSelection(),
          ],
        ),
      ),
    );
  }
}
