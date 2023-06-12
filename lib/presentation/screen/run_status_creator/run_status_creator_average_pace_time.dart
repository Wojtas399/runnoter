part of 'run_status_creator_screen.dart';

class _AveragePaceTime extends StatelessWidget {
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (RunStatusCreatorBloc bloc) => bloc.state.status,
    );
    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == RunStatusCreatorBlocInfo.runStatusInitialized) {
      final Pace? avgPace = context.read<RunStatusCreatorBloc>().state.avgPace;
      if (avgPace != null) {
        final ConvertedPace convertedPace = context.convertPaceFromDefaultUnit(
          avgPace,
        );
        if (convertedPace is ConvertedPaceTime) {
          _minutesController.text = convertedPace.minutes.toString();
          _secondsController.text = convertedPace.seconds.toString();
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelLarge(
          '${Str.of(context).runStatusCreatorAveragePace} [${context.paceUnit.toUIFormat()}]',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _AveragePaceField(
              label: Str.of(context).runStatusCreatorMinutes,
              controller: _minutesController,
              onChanged: () {
                _onPaceChanged(context);
              },
            ),
            const TitleLarge(':'),
            _AveragePaceField(
              label: Str.of(context).runStatusCreatorSeconds,
              controller: _secondsController,
              onChanged: () {
                _onPaceChanged(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  void _onPaceChanged(BuildContext context) {
    final int minutes = int.tryParse(_minutesController.text) ?? 0;
    final int seconds = int.tryParse(_secondsController.text) ?? 0;
    ConvertedPace? convertedPace;
    if (context.paceUnit == PaceUnit.minutesPerKilometer) {
      convertedPace = ConvertedPaceMinutesPerKilometer(
        minutes: minutes,
        seconds: seconds,
      );
    } else if (context.paceUnit == PaceUnit.minutesPerMile) {
      convertedPace = ConvertedPaceMinutesPerMile(
        minutes: minutes,
        seconds: seconds,
      );
    }
    if (convertedPace != null) {
      final Pace pace = context.convertPaceToDefaultUnit(convertedPace);
      context.read<RunStatusCreatorBloc>().add(
            RunStatusCreatorEventAvgPaceChanged(avgPace: pace),
          );
    }
  }
}

class _AveragePaceField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final Function() onChanged;

  const _AveragePaceField({
    required this.label,
    this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: TextFieldComponent(
          label: label,
          isLabelCentered: true,
          textAlign: TextAlign.center,
          controller: controller,
          maxLength: 2,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            MinutesOrSecondsInputFormatter(),
          ],
          onChanged: (_) {
            onChanged();
          },
        ),
      ),
    );
  }
}
