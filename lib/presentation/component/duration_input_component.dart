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
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final int? hours = widget.initialDuration?.inHours;
    final int minutes = (widget.initialDuration?.inMinutes ?? 0) % 60;
    final int seconds = (widget.initialDuration?.inSeconds ?? 0) % 60;
    if (hours != null && hours > 0) {
      _hoursController.text = '$hours';
    }
    if (minutes > 0) {
      _minutesController.text = '$minutes';
    }
    if (seconds > 0) {
      _secondsController.text = '$seconds';
    }
    _hoursController.addListener(_onDurationChanged);
    _minutesController.addListener(_onDurationChanged);
    _secondsController.addListener(_onDurationChanged);
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
              label: Str.of(context).durationHoursShort,
              controller: _hoursController,
            ),
            const _TimeSeparator(),
            _DurationField(
              label: Str.of(context).durationMinutesShort,
              controller: _minutesController,
            ),
            const _TimeSeparator(),
            _DurationField(
              label: Str.of(context).durationSecondsShort,
              controller: _secondsController,
            ),
          ],
        ),
      ],
    );
  }

  void _onDurationChanged() {
    final Duration duration = Duration(
      hours: int.tryParse(_hoursController.text) ?? 0,
      minutes: int.tryParse(_minutesController.text) ?? 0,
      seconds: int.tryParse(_secondsController.text) ?? 0,
    );
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
  final TextEditingController controller;

  const _DurationField({
    required this.label,
    required this.controller,
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
        controller: controller,
      ),
    );
  }
}
