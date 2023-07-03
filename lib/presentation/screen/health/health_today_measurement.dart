part of 'health_screen.dart';

class _TodayMeasurement extends StatelessWidget {
  const _TodayMeasurement();

  @override
  Widget build(BuildContext context) {
    final HealthMeasurement? thisHealthMeasurement = context.select(
      (HealthBloc bloc) => bloc.state.todayMeasurement,
    );

    if (thisHealthMeasurement == null) {
      return const _TodayMeasurementButton();
    }
    return _TodayMeasurementPreview(
      measurement: thisHealthMeasurement,
    );
  }
}

class _TodayMeasurementPreview extends StatelessWidget {
  final HealthMeasurement measurement;

  const _TodayMeasurementPreview({
    required this.measurement,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _HealthMeasurementParam(
              label: Str.of(context).healthRestingHeartRate,
              value:
                  '${measurement.restingHeartRate} ${Str.of(context).heartRateUnit}',
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: _HealthMeasurementParam(
              label: Str.of(context).healthFastingWeight,
              value: '${measurement.fastingWeight} kg',
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthMeasurementParam extends StatelessWidget {
  final String label;
  final String value;

  const _HealthMeasurementParam({
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

class _TodayMeasurementButton extends StatelessWidget {
  const _TodayMeasurementButton();

  @override
  Widget build(BuildContext context) {
    return BigButton(
      label: Str.of(context).healthAddTodayMeasurementButton,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(
      context: context,
      route: HealthMeasurementCreatorRoute(
        date: DateTime.now(),
      ),
    );
  }
}
