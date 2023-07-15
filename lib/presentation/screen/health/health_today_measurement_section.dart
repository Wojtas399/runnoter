part of 'health_screen.dart';

class _TodayMeasurementSection extends StatelessWidget {
  const _TodayMeasurementSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleMedium(Str.of(context).healthTodayMeasurement),
              const _TodayMeasurementActions(),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: _TodayMeasurement(),
        )
      ],
    );
  }
}

class _TodayMeasurementActions extends StatelessWidget {
  const _TodayMeasurementActions();

  @override
  Widget build(BuildContext context) {
    return EditDeleteActions(
      displayAsPopupMenu: context.isMobileSize,
    );
  }

  void _editMeasurement() {
    //TODO
  }

  void _deleteMeasurement() {
    //TODO
  }
}

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
    final str = Str.of(context);

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _HealthMeasurementParam(
              label: str.healthRestingHeartRate,
              value: '${measurement.restingHeartRate} ${str.heartRateUnit}',
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: _HealthMeasurementParam(
              label: str.healthFastingWeight,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BigButton(
          label: Str.of(context).healthAddTodayMeasurementButton,
          onPressed: () => _onPressed(context),
        ),
      ],
    );
  }

  Future<void> _onPressed(BuildContext context) async =>
      await showHealthMeasurementCreatorDialog(
        context: context,
        date: DateTime.now(),
      );
}
