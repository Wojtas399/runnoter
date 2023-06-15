part of 'workout_stage_creator_screen.dart';

class _DistanceStageForm extends StatelessWidget {
  const _DistanceStageForm();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
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
          '${Str.of(context).workoutStageCreatorDistance} [${context.distanceUnit.toUIShortFormat()}]',
      keyboardType: TextInputType.number,
      maxLength: 8,
      isRequired: true,
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
    double? distance;
    if (value.isEmpty) {
      distance = 0;
    } else {
      distance = double.tryParse(value);
    }
    if (distance != null) {
      final convertedDistance = context.convertDistanceToDefaultUnit(distance);
      context.read<WorkoutStageCreatorBloc>().add(
            WorkoutStageCreatorEventDistanceChanged(
              distanceInKm: convertedDistance,
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
      label: Str.of(context).workoutStageCreatorMaxHeartRate,
      keyboardType: TextInputType.number,
      maxLength: 3,
      isRequired: true,
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
    int? maxHeartRate;
    if (value.isEmpty) {
      maxHeartRate = 0;
    } else {
      maxHeartRate = int.tryParse(value);
    }
    if (maxHeartRate != null) {
      context.read<WorkoutStageCreatorBloc>().add(
            WorkoutStageCreatorEventMaxHeartRateChanged(
              maxHeartRate: maxHeartRate,
            ),
          );
    }
  }
}
