import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/entity/health_measurement.dart';
import 'big_button_component.dart';
import 'gap/gap_components.dart';
import 'nullable_text_component.dart';
import 'text/label_text_components.dart';
import 'text/title_text_components.dart';

class HealthMeasurementInfo extends StatelessWidget {
  final String? label;
  final HealthMeasurement? healthMeasurement;
  final bool displayBigButtonIfHealthMeasurementIsNull;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const HealthMeasurementInfo({
    super.key,
    this.label,
    this.healthMeasurement,
    this.displayBigButtonIfHealthMeasurementIsNull = false,
    this.onEdit,
    this.onDelete,
  });

  bool get _canModify => onEdit != null || onDelete != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || _canModify)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null) TitleMedium(label!),
              if (_canModify)
                Row(
                  children: [
                    if (onEdit != null &&
                        (healthMeasurement != null ||
                            displayBigButtonIfHealthMeasurementIsNull == false))
                      IconButton(
                        onPressed: onEdit,
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    if (onDelete != null && healthMeasurement != null)
                      IconButton(
                        onPressed: onDelete,
                        icon: Icon(
                          Icons.delete_outline,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        if (label == null && !_canModify)
          const SizedBox()
        else if (_canModify &&
            (healthMeasurement != null ||
                !displayBigButtonIfHealthMeasurementIsNull))
          const SizedBox(height: 4)
        else
          const Gap16(),
        if (displayBigButtonIfHealthMeasurementIsNull &&
            healthMeasurement == null &&
            onEdit != null)
          _AddMeasurementButton(onPressed: onEdit!)
        else
          _Measurements(healthMeasurement: healthMeasurement),
      ],
    );
  }
}

class _Measurements extends StatelessWidget {
  final HealthMeasurement? healthMeasurement;

  const _Measurements({this.healthMeasurement});

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _ValueWithLabel(
              label: str.restingHeartRate,
              value: healthMeasurement != null
                  ? '${healthMeasurement!.restingHeartRate} ${str.heartRateUnit}'
                  : null,
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: _ValueWithLabel(
              label: Str.of(context).fastingWeight,
              value: healthMeasurement != null
                  ? '${healthMeasurement!.fastingWeight} kg'
                  : null,
            ),
          )
        ],
      ),
    );
  }
}

class _ValueWithLabel extends StatelessWidget {
  final String label;
  final String? value;

  const _ValueWithLabel({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelMedium(label),
        const SizedBox(height: 4),
        NullableText(value),
      ],
    );
  }
}

class _AddMeasurementButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddMeasurementButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigButton(
            label: Str.of(context).addHealthMeasurement,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
