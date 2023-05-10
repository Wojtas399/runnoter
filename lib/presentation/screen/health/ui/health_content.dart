part of 'health_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: const [
            _ThisMorningMeasurement(),
            SizedBox(height: 24),
            _ChartRangeSelection(),
          ],
        ),
      ),
    );
  }
}
