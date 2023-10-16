import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/entity/user.dart';
import '../../../../data/model/activity.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/text/label_text_components.dart';
import '../../../component/text/title_text_components.dart';
import '../../../cubit/activity_status_creator/activity_status_creator_cubit.dart';
import '../../../extension/context_extensions.dart';
import '../../../formatter/decimal_text_input_formatter.dart';
import '../../../formatter/minutes_or_seconds_input_formatter.dart';
import '../../../formatter/pace_unit_formatter.dart';
import '../../../service/pace_unit_service.dart';

class ActivityStatusCreatorAvgPace extends StatelessWidget {
  const ActivityStatusCreatorAvgPace({super.key});

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
    final Pace? avgPace =
        context.read<ActivityStatusCreatorCubit>().state.avgPace;
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
    return TextField(
      decoration: InputDecoration(
        label: Text(
          '${Str.of(context).activityStatusAvgPace} [${context.paceUnit.toUIFormat()}]',
        ),
        counterText: '',
      ),
      controller: _controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      maxLength: 5,
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 2),
      ],
      onSubmitted: (_) => _onSubmitted(context),
    );
  }

  void _onChanged() {
    final double distance = double.tryParse(_controller.text) ?? 0;
    if (distance == 0) {
      const Pace avgPace = Pace(minutes: 0, seconds: 0);
      context.read<ActivityStatusCreatorCubit>().avgPaceChanged(avgPace);
      return;
    }
    ConvertedPace? convertedAvgPace;
    if (context.paceUnit == PaceUnit.kilometersPerHour) {
      convertedAvgPace = ConvertedPaceKilometersPerHour(distance: distance);
    } else if (context.paceUnit == PaceUnit.milesPerHour) {
      convertedAvgPace = ConvertedPaceMilesPerHour(distance: distance);
    }
    if (convertedAvgPace != null) {
      final Pace avgPace = context.convertPaceToDefaultUnit(convertedAvgPace);
      context.read<ActivityStatusCreatorCubit>().avgPaceChanged(avgPace);
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
    final Pace? avgPace =
        context.read<ActivityStatusCreatorCubit>().state.avgPace;
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
          '${Str.of(context).activityStatusAvgPace} [${context.paceUnit.toUIFormat()}]',
        ),
        const Gap16(),
        Row(
          children: [
            _AveragePaceField(
              label: Str.of(context).activityStatusCreatorMinutes,
              controller: _minutesController,
            ),
            const TitleLarge(':'),
            _AveragePaceField(
              label: Str.of(context).activityStatusCreatorSeconds,
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
    ConvertedPace? convertedAvgPace;
    if (context.paceUnit == PaceUnit.minutesPerKilometer) {
      convertedAvgPace = ConvertedPaceMinutesPerKilometer(
        minutes: minutes,
        seconds: seconds,
      );
    } else if (context.paceUnit == PaceUnit.minutesPerMile) {
      convertedAvgPace = ConvertedPaceMinutesPerMile(
        minutes: minutes,
        seconds: seconds,
      );
    }
    if (convertedAvgPace != null) {
      final Pace avgPace = context.convertPaceToDefaultUnit(convertedAvgPace);
      context.read<ActivityStatusCreatorCubit>().avgPaceChanged(avgPace);
    }
  }
}

class _AveragePaceField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;

  const _AveragePaceField({required this.label, this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: TextField(
          decoration: InputDecoration(
            label: Center(
              child: Text(label),
            ),
            counterText: '',
          ),
          textAlign: TextAlign.center,
          controller: controller,
          maxLength: 2,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            MinutesOrSecondsInputFormatter(),
          ],
          onSubmitted: (_) => _onSubmitted(context),
        ),
      ),
    );
  }
}

void _onSubmitted(BuildContext context) {
  final cubit = context.read<ActivityStatusCreatorCubit>();
  if (cubit.state.canSubmit) cubit.submit();
}
