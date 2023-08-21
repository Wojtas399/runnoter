import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../gap/gap_components.dart';
import '../nullable_text_component.dart';
import '../text/label_text_components.dart';

class CalendarComponentHealthData extends StatelessWidget {
  const CalendarComponentHealthData({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _ValueWithLabel(
              label: Str.of(context).healthRestingHeartRate,
              value: '49 bpm',
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: _ValueWithLabel(
              label: Str.of(context).healthFastingWeight,
              value: '79.2 kg',
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
