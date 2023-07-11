part of 'health_measurements_screen.dart';

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
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: BodyMedium(
              widget.measurement.date.toDateWithDots(),
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              widget.measurement.restingHeartRate.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              widget.measurement.fastingWeight.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: _MeasurementActions(
              measurementDate: widget.measurement.date,
            ),
          ),
        ],
      ),
    );
  }
}

class _MeasurementActions extends StatelessWidget {
  final DateTime measurementDate;

  const _MeasurementActions({
    required this.measurementDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (context.isMobileSize)
          EditDeletePopupMenu(
            onEditSelected: () => _editMeasurement(context),
            onDeleteSelected: () => _deleteMeasurement(context),
          ),
        if (!context.isMobileSize)
          IconButton(
            onPressed: () => _editMeasurement(context),
            icon: const Icon(Icons.edit_outlined),
          ),
        if (!context.isMobileSize)
          IconButton(
            onPressed: () => _deleteMeasurement(context),
            icon: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
      ],
    );
  }

  Future<void> _editMeasurement(BuildContext context) async =>
      await showHealthMeasurementCreatorDialog(
        context: context,
        date: measurementDate,
      );

  Future<void> _deleteMeasurement(BuildContext context) async {
    final bloc = context.read<HealthMeasurementsBloc>();
    final str = Str.of(context);
    final bool confirmation = await askForConfirmation(
      title: str.healthMeasurementsDeleteMeasurementConfirmationDialogTitle,
      message: str.healthMeasurementsDeleteMeasurementConfirmationDialogMessage(
        measurementDate.toDateWithDots(),
      ),
      confirmButtonLabel: str.delete,
    );
    if (confirmation == true) {
      bloc.add(
        HealthMeasurementsEventDeleteMeasurement(date: measurementDate),
      );
    }
  }
}
