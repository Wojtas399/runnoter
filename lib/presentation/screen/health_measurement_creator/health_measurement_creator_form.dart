part of 'health_measurement_creator_dialog.dart';

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 24);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _Date(),
        gap,
        const _RestingHeartRate(),
        gap,
        const _FastingWeight(),
        gap,
        if (context.isMobileSize) const _SubmitButton(),
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
        const SizedBox(height: 8),
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
    return TextFieldComponent(
      label:
          '${Str.of(context).healthRestingHeartRate} [${Str.of(context).heartRateUnit}]',
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

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (HealthMeasurementCreatorBloc bloc) => !bloc.state.canSubmit,
    );
    final String label = Str.of(context).save;

    return context.isMobileSize
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BigButton(
                label: label,
                onPressed: () => _onPressed(context),
                isDisabled: isDisabled,
              ),
            ],
          )
        : FilledButton(
            onPressed: isDisabled ? null : () => _onPressed(context),
            child: Text(label),
          );
  }

  void _onPressed(BuildContext context) {
    unfocusInputs();
    context.read<HealthMeasurementCreatorBloc>().add(
          const HealthMeasurementCreatorEventSubmit(),
        );
  }
}
