part of 'health_screen.dart';

class _MorningMeasurementDialog extends StatefulWidget {
  const _MorningMeasurementDialog();

  @override
  State<StatefulWidget> createState() => _MorningMeasurementDialogState();
}

class _MorningMeasurementDialogState extends State<_MorningMeasurementDialog> {
  final _restingHeartRateController = TextEditingController();
  final _weightController = TextEditingController();
  bool _isSubmitButtonDisabled = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<HealthBloc, HealthState>(
      listener: _onHealthStateChanged,
      child: FullScreenDialog(
        title: Str.of(context).healthMorningMeasurement,
        isSubmitButtonDisabled: _isSubmitButtonDisabled,
        onSubmitButtonPressed: () {
          _onSubmitButtonPressed(context);
        },
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
                  TextFieldComponent(
                    label:
                        '${Str.of(context).healthRestingHeartRate} [${Str.of(context).heartRateUnit}]',
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    isRequired: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: _restingHeartRateController,
                    onChanged: _onRestingHeartRateChanged,
                  ),
                  const SizedBox(height: 24),
                  TextFieldComponent(
                    label: '${Str.of(context).healthFastingWeight} [kg]',
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    isRequired: true,
                    inputFormatters: [
                      DecimalTextInputFormatter(decimalRange: 2),
                    ],
                    controller: _weightController,
                    onChanged: _onWeightChanged,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onHealthStateChanged(BuildContext context, HealthState state) {
    final BlocStatus blocStatus = state.status;
    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == HealthBlocInfo.morningMeasurementAdded) {
      navigateBack(context: context);
    }
  }

  void _onRestingHeartRateChanged(String? restingHeartRateStr) {
    setState(() {
      _isSubmitButtonDisabled = restingHeartRateStr?.isEmpty == true ||
          _weightController.text.isEmpty;
    });
  }

  void _onWeightChanged(String? weightStr) {
    setState(() {
      _isSubmitButtonDisabled = weightStr?.isEmpty == true ||
          _restingHeartRateController.text.isEmpty;
    });
  }

  void _onSubmitButtonPressed(BuildContext context) {
    unfocusInputs();
    final int? restingHeartRate = int.tryParse(
      _restingHeartRateController.text,
    );
    final double? weight = double.tryParse(_weightController.text);
    if (restingHeartRate != null && weight != null) {
      context.read<HealthBloc>().add(
            HealthEventAddMorningMeasurement(
              restingHeartRate: restingHeartRate,
              weight: weight,
            ),
          );
    }
  }
}
