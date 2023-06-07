part of 'competition_creator_screen.dart';

class _ExpectedDuration extends StatefulWidget {
  const _ExpectedDuration();

  @override
  State<StatefulWidget> createState() => _ExpectedDurationState();
}

class _ExpectedDurationState extends State<_ExpectedDuration> {
  late int _hours, _minutes, _seconds;

  @override
  void initState() {
    super.initState();
    _hours = 0;
    _minutes = 0;
    _seconds = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleMedium(
          Str.of(context).competitionCreatorExpectedDuration,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _DurationField(
              label:
                  Str.of(context).competitionCreatorExpectedDurationHoursShort,
              onChanged: _onHoursChanged,
            ),
            const _TimeSeparator(),
            _DurationField(
              label: Str.of(context)
                  .competitionCreatorExpectedDurationMinutesShort,
              onChanged: _onMinutesChanged,
            ),
            const _TimeSeparator(),
            _DurationField(
              label: Str.of(context)
                  .competitionCreatorExpectedDurationSecondsShort,
              onChanged: _onSecondsChanged,
            ),
          ],
        ),
      ],
    );
  }

  void _onHoursChanged(int? hours) {
    final Duration duration = Duration(
      hours: hours ?? 0,
      minutes: _minutes,
      seconds: _seconds,
    );
    context.read<CompetitionCreatorBloc>().add(
          CompetitionCreatorEventExpectedDurationChanged(
            expectedDuration: duration,
          ),
        );
    setState(() {
      _hours = hours ?? 0;
    });
  }

  void _onMinutesChanged(int? minutes) {
    final Duration duration = Duration(
      hours: _hours,
      minutes: minutes ?? 0,
      seconds: _seconds,
    );
    context.read<CompetitionCreatorBloc>().add(
          CompetitionCreatorEventExpectedDurationChanged(
            expectedDuration: duration,
          ),
        );
    setState(() {
      _minutes = minutes ?? 0;
    });
  }

  void _onSecondsChanged(int? seconds) {
    final Duration duration = Duration(
      hours: _hours,
      minutes: _minutes,
      seconds: seconds ?? 0,
    );
    context.read<CompetitionCreatorBloc>().add(
          CompetitionCreatorEventExpectedDurationChanged(
            expectedDuration: duration,
          ),
        );
    setState(() {
      _seconds = seconds ?? 0;
    });
  }
}

class _TimeSeparator extends StatelessWidget {
  const _TimeSeparator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TitleLarge(':'),
    );
  }
}

class _DurationField extends StatelessWidget {
  final String label;
  final Function(int? value) onChanged;

  const _DurationField({
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFieldComponent(
        label: label,
        isLabelCentered: true,
        textAlign: TextAlign.center,
        maxLength: 2,
        keyboardType: TextInputType.number,
        onChanged: _onChanged,
      ),
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
