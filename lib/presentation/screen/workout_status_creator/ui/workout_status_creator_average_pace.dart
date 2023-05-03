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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _AveragePaceMinutes(),
              ),
            ),
            Text(
              ':',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (WorkoutStatusCreatorBloc bloc) => bloc.state.status,
    );
    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == WorkoutStatusCreatorInfo.workoutStatusInitialized) {
      _controller.text = context
              .read<WorkoutStatusCreatorBloc>()
              .state
              .averagePaceMinutes
              ?.toString() ??
          '';
    }

    return _AveragePaceField(
      label: AppLocalizations.of(context)!.workout_status_creator_minutes_label,
      controller: _controller,
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
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (WorkoutStatusCreatorBloc bloc) => bloc.state.status,
    );
    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == WorkoutStatusCreatorInfo.workoutStatusInitialized) {
      _controller.text = context
              .read<WorkoutStatusCreatorBloc>()
              .state
              .averagePaceSeconds
              ?.toString() ??
          '';
    }

    return _AveragePaceField(
      label: AppLocalizations.of(context)!.workout_status_creator_seconds_label,
      controller: _controller,
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
  final TextEditingController? controller;
  final Function(int? value) onChanged;

  const _AveragePaceField({
    required this.label,
    this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: label,
      isLabelCentered: true,
      textAlign: TextAlign.center,
      controller: controller,
      maxLength: 2,
      keyboardType: TextInputType.number,
      isRequired: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        MinutesOrSecondsInputFormatter(),
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
