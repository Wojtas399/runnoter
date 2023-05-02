part of 'workout_status_creator_screen.dart';

class _AveragePace extends StatelessWidget {
  const _AveragePace();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!
              .workout_status_creator_average_pace_label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _AveragePaceMinutes(),
              ),
            ),
            Text(
              ':',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _AveragePaceSeconds(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AveragePaceMinutes extends StatelessWidget {
  const _AveragePaceMinutes();

  @override
  Widget build(BuildContext context) {
    return _AveragePaceField(
      label: AppLocalizations.of(context)!.workout_status_creator_minutes_label,
      onChanged: (int? minutes) {
        _onChanged(context, minutes);
      },
    );
  }

  void _onChanged(BuildContext context, int? minutes) {
    context.read<WorkoutStatusCreatorBloc>().add(
          WorkoutStatusCreatorEventAvgPaceMinutesChanged(
            minutes: minutes,
          ),
        );
  }
}

class _AveragePaceSeconds extends StatelessWidget {
  const _AveragePaceSeconds();

  @override
  Widget build(BuildContext context) {
    return _AveragePaceField(
      label: AppLocalizations.of(context)!.workout_status_creator_seconds_label,
      onChanged: (int? seconds) {
        _onChanged(context, seconds);
      },
    );
  }

  void _onChanged(BuildContext context, int? seconds) {
    context.read<WorkoutStatusCreatorBloc>().add(
          WorkoutStatusCreatorEventAvgPaceSecondsChanged(
            seconds: seconds,
          ),
        );
  }
}

class _AveragePaceField extends StatelessWidget {
  final String label;
  final Function(int? value) onChanged;

  const _AveragePaceField({
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: label,
      isLabelCentered: true,
      textAlign: TextAlign.center,
      maxLength: 2,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: _onChanged,
    );
  }

  void _onChanged(String? value) {
    if (value != null) {
      onChanged(
        int.tryParse(value),
      );
    }
  }
}
