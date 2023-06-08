import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'text/title_text_components.dart';
import 'text_field_component.dart';

class DurationInput extends StatefulWidget {
  final String label;
  final Duration? initialDuration;
  final Function(Duration duration)? onDurationChanged;

  const DurationInput({
    super.key,
    required this.label,
    this.initialDuration,
    this.onDurationChanged,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DurationInput> {
  late int _hours, _minutes, _seconds;

  @override
  void initState() {
    super.initState();
    _hours = widget.initialDuration?.inHours ?? 0;
    _minutes = (widget.initialDuration?.inMinutes ?? 0) % 60;
    _seconds = (widget.initialDuration?.inSeconds ?? 0) % 60;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleMedium(widget.label),
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
    _emitUpdatedDuration(duration);
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
    _emitUpdatedDuration(duration);
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
    _emitUpdatedDuration(duration);
    setState(() {
      _seconds = seconds ?? 0;
    });
  }

  void _emitUpdatedDuration(Duration duration) {
    if (widget.onDurationChanged != null) {
      widget.onDurationChanged!(duration);
    }
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
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
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
