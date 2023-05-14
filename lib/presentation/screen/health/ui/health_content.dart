part of 'health_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
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

class _ShowAllMeasurementsButton extends StatelessWidget {
  const _ShowAllMeasurementsButton();

  @override
  Widget build(BuildContext context) {
    return BigButton(
      label: Str.of(context).healthShowAllMeasurementsButton,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(
      context: context,
      route: const HealthMeasurementsRoute(),
    );
  }
}
