part of 'health_screen.dart';

class _TodayMeasurementSection extends StatelessWidget {
  const _TodayMeasurementSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TodayMeasurementSectionHeader(),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: _TodayMeasurement(),
        )
      ],
    );
  }
}

class _TodayMeasurementSectionHeader extends StatelessWidget {
  const _TodayMeasurementSectionHeader();

  @override
  Widget build(BuildContext context) {
    final bool doesTodayMeasurementExist = context.select(
      (HealthBloc bloc) => bloc.state.todayMeasurement != null,
    );

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 16,
        top: doesTodayMeasurementExist ? 0 : 8,
        bottom: doesTodayMeasurementExist ? 0 : 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleMedium(Str.of(context).healthTodayMeasurement),
          if (doesTodayMeasurementExist) const _TodayMeasurementActions(),
        ],
      ),
    );
  }
}

class _TodayMeasurementActions extends StatelessWidget {
  const _TodayMeasurementActions();

  @override
  Widget build(BuildContext context) {
    return EditDeleteActions(
      displayAsPopupMenu: context.isMobileSize,
      onEditSelected: () => _editMeasurement(context),
      onDeleteSelected: () => _deleteMeasurement(context),
    );
  }

  Future<void> _editMeasurement(BuildContext context) async =>
      await showHealthMeasurementCreatorDialog(
        context: context,
        date: DateTime.now(),
      );

  Future<void> _deleteMeasurement(BuildContext context) async {
    final bloc = context.read<HealthBloc>();
    final str = Str.of(context);
    final bool confirmation = await askForConfirmation(
      title: str.healthDeleteTodayMeasurementConfirmationDialogTitle,
      message: str.healthDeleteTodayMeasurementConfirmationDialogMessage,
      confirmButtonLabel: str.delete,
      confirmButtonColor: Theme.of(context).colorScheme.error,
    );
    if (confirmation == true) {
      bloc.add(const HealthEventDeleteTodayMeasurement());
    }
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
