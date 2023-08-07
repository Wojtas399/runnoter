import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/health_measurement_creator/health_measurement_creator_bloc.dart';
import '../../component/date_selector_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/text/title_text_components.dart';
import '../../component/text_field_component.dart';
import '../../formatter/decimal_text_input_formatter.dart';

class HealthMeasurementCreatorForm extends StatelessWidget {
  const HealthMeasurementCreatorForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Date(),
        Gap24(),
        _RestingHeartRate(),
        Gap24(),
        _FastingWeight(),
      ],
    );
  }
}

class _Date extends StatelessWidget {
  const _Date();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (HealthMeasurementCreatorBloc bloc) => bloc.state.date,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleMedium(Str.of(context).date),
        const Gap8(),
        DateSelector(
          date: date,
          lastDate: DateTime.now(),
          onDateSelected: (DateTime date) {
            _onDateSelected(context, date);
          },
        ),
      ],
    );
  }

  void _onDateSelected(BuildContext context, DateTime date) {
    context.read<HealthMeasurementCreatorBloc>().add(
          HealthMeasurementCreatorEventDateChanged(date: date),
        );
  }
}

class _RestingHeartRate extends StatefulWidget {
  const _RestingHeartRate();

  @override
  State<StatefulWidget> createState() => _RestingHeartRateState();
}

class _RestingHeartRateState extends State<_RestingHeartRate> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = context
            .read<HealthMeasurementCreatorBloc>()
            .state
            .restingHeartRate
            ?.toString() ??
        '';
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
    final str = Str.of(context);
    return TextFieldComponent(
      label: '${str.healthRestingHeartRate} [${str.heartRateUnit}]',
      keyboardType: TextInputType.number,
      maxLength: 3,
      isRequired: true,
      requireHigherThan0: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: _controller,
    );
  }

  void _onChanged() {
    final int restingHeartRate = int.tryParse(_controller.text) ?? 0;
    context.read<HealthMeasurementCreatorBloc>().add(
          HealthMeasurementCreatorEventRestingHeartRateChanged(
            restingHeartRate: restingHeartRate,
          ),
        );
  }
}

class _FastingWeight extends StatefulWidget {
  const _FastingWeight();

  @override
  State<StatefulWidget> createState() => _FastingWeightState();
}

class _FastingWeightState extends State<_FastingWeight> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = context
            .read<HealthMeasurementCreatorBloc>()
            .state
            .fastingWeight
            ?.toString() ??
        '';
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
      label: '${Str.of(context).healthFastingWeight} [kg]',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      maxLength: 6,
      isRequired: true,
      requireHigherThan0: true,
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 2),
      ],
      controller: _controller,
    );
  }

  void _onChanged() {
    final double fastingWeight = double.tryParse(_controller.text) ?? 0;
    context.read<HealthMeasurementCreatorBloc>().add(
          HealthMeasurementCreatorEventFastingWeightChanged(
            fastingWeight: fastingWeight,
          ),
        );
  }
}
