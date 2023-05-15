part of 'health_measurement_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health measurement creator'),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            unfocusInputs();
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _RestingHeartRate(),
                const SizedBox(height: 24),
                _FastingWeight(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RestingHeartRate extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (HealthMeasurementCreatorBloc bloc) => bloc.state.status,
    );

    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == HealthMeasurementCreatorBlocInfo.measurementLoaded) {
      final int? restingHeartRate =
          context.read<HealthMeasurementCreatorBloc>().state.restingHeartRate;
      _controller.text = restingHeartRate?.toString() ?? '';
    }

    return TextFieldComponent(
      label:
          '${Str.of(context).healthRestingHeartRate} [${Str.of(context).heartRateUnit}]',
      keyboardType: TextInputType.number,
      maxLength: 3,
      isRequired: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: _controller,
      onChanged: (String? value) {
        _onChanged(context, value);
      },
    );
  }

  void _onChanged(BuildContext context, String? value) {
    if (value != null) {
      final int? restingHeartRate = int.tryParse(value);
      context.read<HealthMeasurementCreatorBloc>().add(
            HealthMeasurementCreatorEventRestingHeartRateChanged(
              restingHeartRate: restingHeartRate,
            ),
          );
    }
  }
}

class _FastingWeight extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (HealthMeasurementCreatorBloc bloc) => bloc.state.status,
    );

    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == HealthMeasurementCreatorBlocInfo.measurementLoaded) {
      final double? fastingWeight =
          context.read<HealthMeasurementCreatorBloc>().state.fastingWeight;
      _controller.text = fastingWeight?.toString() ?? '';
    }

    return TextFieldComponent(
      label: '${Str.of(context).healthFastingWeight} [kg]',
      keyboardType: TextInputType.number,
      maxLength: 6,
      isRequired: true,
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 2),
      ],
      controller: _controller,
      onChanged: (String? value) {
        _onChanged(context, value);
      },
    );
  }

  void _onChanged(BuildContext context, String? value) {
    if (value != null) {
      final double? fastingWeight = double.tryParse(value);
      context.read<HealthMeasurementCreatorBloc>().add(
            HealthMeasurementCreatorEventFastingWeightChanged(
              fastingWeight: fastingWeight,
            ),
          );
    }
  }
}
