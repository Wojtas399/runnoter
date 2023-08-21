import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/entity/health_measurement.dart';
import '../gap/gap_components.dart';
import '../nullable_text_component.dart';
import '../text/label_text_components.dart';

class CalendarComponentHealthData extends StatelessWidget {
  final HealthMeasurement? healthMeasurement;

  const CalendarComponentHealthData({super.key, this.healthMeasurement});

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _ValueWithLabel(
              label: str.healthRestingHeartRate,
              value: healthMeasurement != null
                  ? '${healthMeasurement!.restingHeartRate} ${str.heartRateUnit}'
                  : null,
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: _ValueWithLabel(
              label: Str.of(context).healthFastingWeight,
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
        const Gap8(),
        NullableText(value),
      ],
    );
  }
}
