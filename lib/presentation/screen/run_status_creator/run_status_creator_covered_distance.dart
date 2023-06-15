part of 'run_status_creator_screen.dart';

class _CoveredDistance extends StatefulWidget {
  const _CoveredDistance();

  @override
  State<StatefulWidget> createState() => _CoveredDistanceState();
}

class _CoveredDistanceState extends State<_CoveredDistance> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final double? coveredDistanceInKm =
        context.read<RunStatusCreatorBloc>().state.coveredDistanceInKm;
    if (coveredDistanceInKm != null) {
      _controller.text = context
          .convertDistanceFromDefaultUnit(coveredDistanceInKm)
          .toStringAsFixed(2);
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
          '${Str.of(context).runStatusCreatorCoveredDistance} [${context.distanceUnit.toUIShortFormat()}]',
      maxLength: 8,
      keyboardType: TextInputType.number,
      isRequired: true,
      requireHigherThan0: true,
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 2),
      ],
      controller: _controller,
    );
  }

  void _onChanged() {
    final double coveredDistance = double.tryParse(_controller.text) ?? 0;
    final double convertedCoveredDistance =
        context.convertDistanceToDefaultUnit(coveredDistance);
    context.read<RunStatusCreatorBloc>().add(
          RunStatusCreatorEventCoveredDistanceInKmChanged(
            coveredDistanceInKm: convertedCoveredDistance,
          ),
        );
  }
}
