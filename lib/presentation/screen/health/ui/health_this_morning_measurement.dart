part of 'health_screen.dart';

class _ThisMorningMeasurement extends StatelessWidget {
  const _ThisMorningMeasurement();

  @override
  Widget build(BuildContext context) {
    final MorningMeasurement? thisMorningMeasurement = context.select(
      (HealthBloc bloc) => bloc.state.thisMorningMeasurement,
    );

    if (thisMorningMeasurement == null) {
      return const _ThisMorningMeasurementButton();
    }
    return _ThisMorningMeasurementPreview(
      measurement: thisMorningMeasurement,
    );
  }
}

class _ThisMorningMeasurementPreview extends StatelessWidget {
  final MorningMeasurement measurement;

  const _ThisMorningMeasurementPreview({
    required this.measurement,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _MorningMeasurementParam(
              label: Str.of(context).healthRestingHeartRate,
              value:
                  '${measurement.restingHeartRate} ${Str.of(context).heartRateUnit}',
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: _MorningMeasurementParam(
              label: Str.of(context).healthFastingWeight,
              value: '${measurement.fastingWeight} kg',
            ),
          ),
        ],
      ),
    );
  }
}

class _MorningMeasurementParam extends StatelessWidget {
  final String label;
  final String value;

  const _MorningMeasurementParam({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}

class _ThisMorningMeasurementButton extends StatelessWidget {
  const _ThisMorningMeasurementButton();

  @override
  Widget build(BuildContext context) {
    return BigButton(
      label: Str.of(context).healthMorningMeasurementButton,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    await showFullScreenDialog(
      context: context,
      dialog: BlocProvider<HealthBloc>.value(
        value: context.read<HealthBloc>(),
        child: const _MorningMeasurementDialog(),
      ),
    );
  }
}
