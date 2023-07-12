part of 'health_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(
              label: Str.of(context).healthTodayMeasurement,
              child: const _TodayMeasurement(),
            ),
            const SizedBox(height: 24),
            _Section(
              label: Str.of(context).healthSummaryOfMeasurements,
              child: const _ChartRangeSelection(),
            ),
            const SizedBox(height: 8),
            const _Charts(),
            const SizedBox(height: 24),
            const _ShowAllMeasurementsButton(),
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
        TitleMedium(label),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}

class _ShowAllMeasurementsButton extends StatelessWidget {
  const _ShowAllMeasurementsButton();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BigButton(
          label: Str.of(context).healthShowAllMeasurementsButton,
          onPressed: _onPressed,
        ),
      ],
    );
  }

  void _onPressed() {
    navigateTo(const HealthMeasurementsRoute());
  }
}
