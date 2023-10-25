import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/model/health_measurement.dart';
import '../../component/edit_delete_popup_menu_component.dart';
import '../../component/text/body_text_components.dart';
import '../../cubit/health_measurements_cubit.dart';
import '../../dialog/health_measurement_creator/health_measurement_creator_dialog.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../../service/dialog_service.dart';

class HealthMeasurementsItem extends StatefulWidget {
  final HealthMeasurement measurement;
  final bool isFirstItem;

  const HealthMeasurementsItem({
    super.key,
    required this.measurement,
    this.isFirstItem = false,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<HealthMeasurementsItem> {
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
        EditDeleteActions(
          displayAsPopupMenu: context.isMobileSize,
          onEditSelected: _editMeasurement,
          onDeleteSelected: () => _deleteMeasurement(context),
        ),
      ],
    );
  }

  Future<void> _editMeasurement() async =>
      await showDialogDependingOnScreenSize(
        HealthMeasurementCreatorDialog(date: measurementDate),
      );

  Future<void> _deleteMeasurement(BuildContext context) async {
    final cubit = context.read<HealthMeasurementsCubit>();
    final str = Str.of(context);
    final bool isDeletionConfirmed =
        await _askForMeasurementDeletionConfirmation(context);
    if (isDeletionConfirmed == true) {
      showLoadingDialog();
      await cubit.deleteMeasurement(measurementDate);
      closeLoadingDialog();
      showSnackbarMessage(str.healthMeasurementsDeletedMeasurementMessage);
    }
  }

  Future<bool> _askForMeasurementDeletionConfirmation(
    BuildContext context,
  ) async {
    final str = Str.of(context);
    return await askForConfirmation(
      title: Text(
        str.healthMeasurementsDeleteMeasurementConfirmationDialogTitle,
      ),
      content: Text(
        str.healthMeasurementsDeleteMeasurementConfirmationDialogMessage(
          measurementDate.toDateWithDots(),
        ),
      ),
      confirmButtonLabel: str.delete,
      confirmButtonColor: Theme.of(context).colorScheme.error,
    );
  }
}
