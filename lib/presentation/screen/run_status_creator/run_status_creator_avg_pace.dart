import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/run_status_creator/run_status_creator_bloc.dart';
import '../../../domain/entity/run_status.dart';
import '../../../domain/entity/settings.dart';
import '../../component/gap_components.dart';
import '../../component/text/label_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../component/text_field_component.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/decimal_text_input_formatter.dart';
import '../../formatter/minutes_or_seconds_input_formatter.dart';
import '../../formatter/pace_unit_formatter.dart';
import '../../service/pace_unit_service.dart';

class RunStatusCreatorAvgPace extends StatelessWidget {
  const RunStatusCreatorAvgPace({super.key});

  @override
  Widget build(BuildContext context) {
    final PaceUnit paceUnit = context.paceUnit;
    return switch (paceUnit) {
      PaceUnit.kilometersPerHour => const _AvgPaceDistance(),
      PaceUnit.milesPerHour => const _AvgPaceDistance(),
      PaceUnit.minutesPerKilometer => const _AvgPaceTime(),
      PaceUnit.minutesPerMile => const _AvgPaceTime(),
    };
  }
}

class _AvgPaceDistance extends StatefulWidget {
  const _AvgPaceDistance();

  @override
  State<StatefulWidget> createState() => _AvgPaceDistanceState();
}

class _AvgPaceDistanceState extends State<_AvgPaceDistance> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final Pace? avgPace = context.read<RunStatusCreatorBloc>().state.avgPace;
    if (avgPace != null) {
      final ConvertedPace convertedPace = context.convertPaceFromDefaultUnit(
        avgPace,
      );
      if (convertedPace is ConvertedPaceDistance) {
        _controller.text = convertedPace.distance.toString();
      }
    }
    _controller.addListener(_onChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label:
          '${Str.of(context).runStatusCreatorAveragePace} [${context.paceUnit.toUIFormat()}]',
      controller: _controller,
      keyboardType: TextInputType.number,
      maxLength: 5,
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 2),
      ],
    );
  }

  void _onChanged() {
    final double distance = double.tryParse(_controller.text) ?? 0;
    if (distance == 0) {
      const Pace pace = Pace(minutes: 0, seconds: 0);
      context.read<RunStatusCreatorBloc>().add(
            const RunStatusCreatorEventAvgPaceChanged(avgPace: pace),
          );
      return;
    }
    ConvertedPace? convertedPace;
    if (context.paceUnit == PaceUnit.kilometersPerHour) {
      convertedPace = ConvertedPaceKilometersPerHour(distance: distance);
    } else if (context.paceUnit == PaceUnit.milesPerHour) {
      convertedPace = ConvertedPaceMilesPerHour(distance: distance);
    }
    if (convertedPace != null) {
      final Pace pace = context.convertPaceToDefaultUnit(convertedPace);
      context.read<RunStatusCreatorBloc>().add(
            RunStatusCreatorEventAvgPaceChanged(avgPace: pace),
          );
    }
  }
}

class _AvgPaceTime extends StatefulWidget {
  const _AvgPaceTime();

  @override
  State<StatefulWidget> createState() => _AvgPaceTimeState();
}

class _AvgPaceTimeState extends State<_AvgPaceTime> {
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  @override
  void initState() {
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
    _minutesController.addListener(_onPaceChanged);
    _secondsController.addListener(_onPaceChanged);
    super.initState();
  }

  @override
  void dispose() {
    _minutesController.removeListener(_onPaceChanged);
    _secondsController.removeListener(_onPaceChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelLarge(
          '${Str.of(context).runStatusCreatorAveragePace} [${context.paceUnit.toUIFormat()}]',
        ),
        const Gap16(),
        Row(
          children: [
            _AveragePaceField(
              label: Str.of(context).runStatusCreatorMinutes,
              controller: _minutesController,
            ),
            const TitleLarge(':'),
            _AveragePaceField(
              label: Str.of(context).runStatusCreatorSeconds,
              controller: _secondsController,
            ),
          ],
        ),
      ],
    );
  }

  void _onPaceChanged() {
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

  const _AveragePaceField({
    required this.label,
    this.controller,
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
        ),
      ),
    );
  }
}
