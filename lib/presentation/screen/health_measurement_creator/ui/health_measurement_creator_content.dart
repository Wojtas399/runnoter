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
                const SizedBox(height: 24),
                const _SubmitButton(),
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
      _controller.text = context
              .read<HealthMeasurementCreatorBloc>()
              .state
              .restingHeartRateStr ??
          '';
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

  void _onChanged(BuildContext context, String? restingHeartRateStr) {
    context.read<HealthMeasurementCreatorBloc>().add(
          HealthMeasurementCreatorEventRestingHeartRateChanged(
            restingHeartRateStr: restingHeartRateStr,
          ),
        );
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
      _controller.text =
          context.read<HealthMeasurementCreatorBloc>().state.fastingWeightStr ??
              '';
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

  void _onChanged(BuildContext context, String? fastingWeightStr) {
    context.read<HealthMeasurementCreatorBloc>().add(
          HealthMeasurementCreatorEventFastingWeightChanged(
            fastingWeightStr: fastingWeightStr,
          ),
        );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (HealthMeasurementCreatorBloc bloc) => bloc.state.isSubmitButtonDisabled,
    );

    return BigButton(
      label: Str.of(context).save,
      onPressed: () {
        _onPressed(context);
      },
      isDisabled: isDisabled,
    );
  }

  void _onPressed(BuildContext context) {
    unfocusInputs();
    context.read<HealthMeasurementCreatorBloc>().add(
          const HealthMeasurementCreatorEventSubmit(),
        );
  }
}
