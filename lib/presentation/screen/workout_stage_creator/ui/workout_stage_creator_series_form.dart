import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/text_field_component.dart';

class WorkoutStageCreatorSeriesForm extends StatelessWidget {
  const WorkoutStageCreatorSeriesForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 16);
    return Column(
      children: const [
        _AmountOfSeries(),
        gap,
        _SeriesDistance(),
        gap,
        _WalkingDistance(),
        gap,
        _JoggingDistance(),
      ],
    );
  }
}

class _AmountOfSeries extends StatelessWidget {
  const _AmountOfSeries();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: AppLocalizations.of(context)!
          .workout_stage_creator_screen_amount_of_series,
      keyboardType: TextInputType.number,
      maxLength: 2,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}

class _SeriesDistance extends StatelessWidget {
  const _SeriesDistance();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label:
          '${AppLocalizations.of(context)!.workout_stage_creator_screen_single_series_distance} [m]',
      keyboardType: TextInputType.number,
      maxLength: 6,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}

class _WalkingDistance extends StatelessWidget {
  const _WalkingDistance();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label:
          '${AppLocalizations.of(context)!.workout_stage_creator_screen_walking_distance} [m]',
      keyboardType: TextInputType.number,
      maxLength: 6,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}

class _JoggingDistance extends StatelessWidget {
  const _JoggingDistance();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label:
          '${AppLocalizations.of(context)!.workout_stage_creator_screen_jogging_distance} [m]',
      keyboardType: TextInputType.number,
      maxLength: 6,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}
