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
      onChanged: (String? value) {
        _onChanged(context, value);
      },
    );
  }

  void _onChanged(BuildContext context, String? value) {
    if (value == null) {
      return;
    }
    final double? distance = double.tryParse(value);
    if (distance != null) {
      context.read<WorkoutStageCreatorBloc>().add(
            WorkoutStageCreatorEventDistanceChanged(
              distanceInKm: distance,
            ),
          );
    }
  }
}

class _MaxHeartRate extends StatelessWidget {
  const _MaxHeartRate();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: AppLocalizations.of(context)!
          .workout_stage_creator_screen_max_heart_rate,
      keyboardType: TextInputType.number,
      maxLength: 3,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (String? value) {
        _onChanged(context, value);
      },
    );
  }

  void _onChanged(BuildContext context, String? value) {
    if (value == null) {
      return;
    }
    final int? maxHeartRate = int.tryParse(value);
    if (maxHeartRate != null) {
      context.read<WorkoutStageCreatorBloc>().add(
            WorkoutStageCreatorEventMaxHeartRateChanged(
              maxHeartRate: maxHeartRate,
            ),
          );
    }
  }
}
