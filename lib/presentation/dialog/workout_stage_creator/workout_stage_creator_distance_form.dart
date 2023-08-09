import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/workout_stage_creator/workout_stage_creator_bloc.dart';
import '../../component/gap/gap_components.dart';
import '../../component/text_field_component.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/decimal_text_input_formatter.dart';
import '../../formatter/distance_unit_formatter.dart';
import '../../service/utils.dart';

class WorkoutStageCreatorDistanceStageForm extends StatelessWidget {
  const WorkoutStageCreatorDistanceStageForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Distance(),
        Gap16(),
        _MaxHeartRate(),
      ],
    );
  }
}

class _Distance extends StatefulWidget {
  const _Distance();

  @override
  State<StatefulWidget> createState() => _DistanceState();
}

class _DistanceState extends State<_Distance> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final double? distanceInKm =
        context.read<WorkoutStageCreatorBloc>().state.distanceForm.distanceInKm;
    if (distanceInKm != null) {
      _controller.text =
          context.convertDistanceFromDefaultUnit(distanceInKm).toString();
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
          '${Str.of(context).workoutStageCreatorDistance} [${context.distanceUnit.toUIShortFormat()}]',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      maxLength: 8,
      isRequired: true,
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 2),
      ],
      controller: _controller,
      onTapOutside: (_) => unfocusInputs(),
    );
  }

  void _onChanged() {
    double? distance;
    if (_controller.text.isEmpty) {
      distance = 0;
    } else {
      distance = double.tryParse(_controller.text);
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

class _MaxHeartRate extends StatefulWidget {
  const _MaxHeartRate();

  @override
  State<StatefulWidget> createState() => _MaxHeartRateState();
}

class _MaxHeartRateState extends State<_MaxHeartRate> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final int? maxHeartRate =
        context.read<WorkoutStageCreatorBloc>().state.distanceForm.maxHeartRate;
    if (maxHeartRate != null) {
      _controller.text = maxHeartRate.toString();
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
      label: Str.of(context).workoutStageCreatorMaxHeartRate,
      keyboardType: TextInputType.number,
      maxLength: 3,
      isRequired: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: _controller,
    );
  }

  void _onChanged() {
    int? maxHeartRate;
    if (_controller.text.isEmpty) {
      maxHeartRate = 0;
    } else {
      maxHeartRate = int.tryParse(_controller.text);
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
