part of 'workout_stage_creator_screen.dart';

class _SeriesStageForm extends StatelessWidget {
  const _SeriesStageForm();

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 16);
    return const Column(
      children: [
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
      label: Str.of(context).workoutStageCreatorAmountOfSeries,
      keyboardType: TextInputType.number,
      maxLength: 2,
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
    int? amountOfSeries;
    if (value == '') {
      amountOfSeries = 0;
    } else {
      amountOfSeries = int.tryParse(value);
    }
    if (amountOfSeries != null) {
      context.read<WorkoutStageCreatorBloc>().add(
            WorkoutStageCreatorEventAmountOfSeriesChanged(
              amountOfSeries: amountOfSeries,
            ),
          );
    }
  }
}

class _SeriesDistance extends StatelessWidget {
  const _SeriesDistance();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: '${Str.of(context).workoutStageCreatorSeriesDistance} [m]',
      keyboardType: TextInputType.number,
      maxLength: 6,
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
    int? seriesDistance;
    if (value == '') {
      seriesDistance = 0;
    } else {
      seriesDistance = int.tryParse(value);
    }
    if (seriesDistance != null) {
      context.read<WorkoutStageCreatorBloc>().add(
            WorkoutStageCreatorEventSeriesDistanceChanged(
              seriesDistanceInMeters: seriesDistance,
            ),
          );
    }
  }
}

class _WalkingDistance extends StatelessWidget {
  const _WalkingDistance();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: '${Str.of(context).workoutStageCreatorWalkingDistance} [m]',
      keyboardType: TextInputType.number,
      maxLength: 6,
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
    int? walkingDistance;
    if (value == '') {
      walkingDistance = 0;
    } else {
      walkingDistance = int.tryParse(value);
    }
    if (walkingDistance != null) {
      context.read<WorkoutStageCreatorBloc>().add(
            WorkoutStageCreatorEventWalkingDistanceChanged(
              walkingDistanceInMeters: walkingDistance,
            ),
          );
    }
  }
}

class _JoggingDistance extends StatelessWidget {
  const _JoggingDistance();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: '${Str.of(context).workoutStageCreatorJoggingDistance} [m]',
      keyboardType: TextInputType.number,
      maxLength: 6,
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
    int? joggingDistance;
    if (value == '') {
      joggingDistance = 0;
    } else {
      joggingDistance = int.tryParse(value);
    }
    if (joggingDistance != null) {
      context.read<WorkoutStageCreatorBloc>().add(
            WorkoutStageCreatorEventJoggingDistanceChanged(
              joggingDistanceInMeters: joggingDistance,
            ),
          );
    }
  }
}