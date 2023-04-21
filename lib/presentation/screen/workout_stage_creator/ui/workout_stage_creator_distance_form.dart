part of 'workout_stage_creator_screen.dart';

class _DistanceStageForm extends StatelessWidget {
  const _DistanceStageForm();

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
      maxLength: 4,
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
