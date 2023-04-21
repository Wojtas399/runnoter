import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/text_field_component.dart';
import '../../../formatter/decimal_text_input_formatter.dart';

class WorkoutStageCreatorDistanceForm extends StatelessWidget {
  const WorkoutStageCreatorDistanceForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _Distance(),
        SizedBox(height: 16),
        _MaxHeartRate(),
      ],
    );
  }
}

class _Distance extends StatelessWidget {
  const _Distance();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label:
          '${AppLocalizations.of(context)!.workout_stage_creator_screen_distance} [km]',
      keyboardType: TextInputType.number,
      inputFormatters: [
        DecimalTextInputFormatter(
          decimalRange: 2,
        ),
      ],
    );
  }
}

class _MaxHeartRate extends StatelessWidget {
  const _MaxHeartRate();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: AppLocalizations.of(context)!
          .workout_stage_creator_screen_max_heart_rate,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
      ),
      maxLength: 3,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}
