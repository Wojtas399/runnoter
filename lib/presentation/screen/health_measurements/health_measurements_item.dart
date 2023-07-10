part of 'health_measurements_screen.dart';

enum _MeasurementAction {
  edit,
  delete,
}

class _MeasurementItem extends StatefulWidget {
  final HealthMeasurement measurement;
  final bool isFirstItem;

  const _MeasurementItem({
    required this.measurement,
    this.isFirstItem = false,
  });

  @override
  State<StatefulWidget> createState() => _MeasurementItemState();
}

class _MeasurementItemState extends State<_MeasurementItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onPressed,
      borderRadius: BorderRadius.circular(32),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelLarge(widget.measurement.date.toDateWithDots()),
            const SizedBox(height: 8),
            _MeasurementParams(
              restingHeartRate: widget.measurement.restingHeartRate,
              fastingWeight: widget.measurement.fastingWeight,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPressed() async {
    final str = Str.of(context);
    final _MeasurementAction? action = await askForAction<_MeasurementAction>(
      actions: [
        ActionSheetItem(
          id: _MeasurementAction.edit,
          label: str.edit,
          iconData: Icons.edit_outlined,
        ),
        ActionSheetItem(
          id: _MeasurementAction.delete,
          label: str.delete,
          iconData: Icons.delete_outline,
        ),
      ],
    );
    if (action == _MeasurementAction.edit) {
      _navigateToHealthMeasurementCreator();
    } else if (action == _MeasurementAction.delete) {
      await _deleteMeasurement();
    }
  }

  void _navigateToHealthMeasurementCreator() {
    navigateTo(
      route: HealthMeasurementCreatorRoute(
        date: widget.measurement.date,
      ),
    );
  }

  Future<void> _deleteMeasurement() async {
    final DateTime date = widget.measurement.date;
    final str = Str.of(context);
    final bool confirmation = await askForConfirmation(
      title: str.healthMeasurementsDeleteMeasurementConfirmationDialogTitle,
      message: str.healthMeasurementsDeleteMeasurementConfirmationDialogMessage(
        date.toDateWithDots(),
      ),
      confirmButtonLabel: str.delete,
    );
    if (confirmation == true && mounted) {
      context.read<HealthMeasurementsBloc>().add(
            HealthMeasurementsEventDeleteMeasurement(date: date),
          );
    }
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
