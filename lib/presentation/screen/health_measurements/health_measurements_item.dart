part of 'health_measurements_screen.dart';

class _MeasurementItem extends StatelessWidget {
  final HealthMeasurement measurement;
  final bool isFirstItem;

  const _MeasurementItem({
    required this.measurement,
    this.isFirstItem = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _onPressed(context);
      },
      borderRadius: BorderRadius.circular(32),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelLarge(measurement.date.toDateWithDots()),
            const SizedBox(height: 8),
            _MeasurementParams(
              restingHeartRate: measurement.restingHeartRate,
              fastingWeight: measurement.fastingWeight,
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(
      context: context,
      route: HealthMeasurementCreatorRoute(
        date: measurement.date,
      ),
    );
  }
}

class _MeasurementParams extends StatelessWidget {
  final int restingHeartRate;
  final double fastingWeight;

  const _MeasurementParams({
    required this.restingHeartRate,
    required this.fastingWeight,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _MeasurementParamWithLabel(
              label: Str.of(context).healthRestingHeartRate,
              value: '$restingHeartRate ${Str.of(context).heartRateUnit}',
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: _MeasurementParamWithLabel(
              label: Str.of(context).healthFastingWeight,
              value: '$fastingWeight kg',
            ),
          ),
        ],
      ),
    );
  }
}

class _MeasurementParamWithLabel extends StatelessWidget {
  final String label;
  final String value;

  const _MeasurementParamWithLabel({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LabelMedium(label),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}
