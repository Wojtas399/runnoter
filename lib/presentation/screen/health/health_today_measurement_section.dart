import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/health/health_bloc.dart';
import '../../../domain/entity/health_measurement.dart';
import '../../component/big_button_component.dart';
import '../../component/edit_delete_popup_menu_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/text/label_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../dialog/health_measurement_creator/health_measurement_creator_dialog.dart';
import '../../extension/context_extensions.dart';
import '../../service/dialog_service.dart';

class HealthTodayMeasurementSection extends StatelessWidget {
  const HealthTodayMeasurementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Header(),
        const Gap8(),
        Padding(
          padding: EdgeInsets.only(right: context.isMobileSize ? 16 : 0),
          child: const _TodayMeasurement(),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final bool doesTodayMeasurementExist = context.select(
      (HealthBloc bloc) => bloc.state.todayMeasurement != null,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TitleMedium(Str.of(context).healthTodayMeasurement),
        if (doesTodayMeasurementExist)
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
        HealthMeasurementCreatorDialog(date: DateTime.now()),
      );

  Future<void> _deleteMeasurement(BuildContext context) async {
    final bloc = context.read<HealthBloc>();
    final str = Str.of(context);
    final bool confirmation = await askForConfirmation(
      title: Text(str.healthDeleteTodayMeasurementConfirmationDialogTitle),
      content: Text(str.healthDeleteTodayMeasurementConfirmationDialogMessage),
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

    return thisHealthMeasurement == null
        ? const _AddMeasurementButton()
        : _MeasurementData(measurement: thisHealthMeasurement);
  }
}

class _MeasurementData extends StatelessWidget {
  final HealthMeasurement measurement;

  const _MeasurementData({required this.measurement});

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _Param(
              label: str.healthRestingHeartRate,
              value: '${measurement.restingHeartRate} ${str.heartRateUnit}',
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: _Param(
              label: str.healthFastingWeight,
              value: '${measurement.fastingWeight} kg',
            ),
          ),
        ],
      ),
    );
  }
}

class _Param extends StatelessWidget {
  final String label;
  final String value;

  const _Param({
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

class _AddMeasurementButton extends StatelessWidget {
  const _AddMeasurementButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigButton(
            label: Str.of(context).healthAddTodayMeasurementButton,
            onPressed: _onPressed,
          ),
        ],
      ),
    );
  }

  Future<void> _onPressed() async => await showDialogDependingOnScreenSize(
        HealthMeasurementCreatorDialog(date: DateTime.now()),
      );
}
