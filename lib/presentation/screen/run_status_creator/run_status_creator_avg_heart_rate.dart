part of 'run_status_creator_screen.dart';

class _AvgHeartRate extends StatefulWidget {
  const _AvgHeartRate();

  @override
  State<StatefulWidget> createState() => _AvgHeartRateState();
}

class _AvgHeartRateState extends State<_AvgHeartRate> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final int? avgHeartRate =
        context.read<RunStatusCreatorBloc>().state.avgHeartRate;
    if (avgHeartRate != null) {
      _controller.text = avgHeartRate.toString();
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
      label: Str.of(context).runStatusCreatorAverageHeartRate,
      maxLength: 3,
      keyboardType: TextInputType.number,
      isRequired: true,
      requireHigherThan0: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: _controller,
    );
  }

  void _onChanged() {
    final int averageHeartRate = int.tryParse(_controller.text) ?? 0;
    context.read<RunStatusCreatorBloc>().add(
          RunStatusCreatorEventAvgHeartRateChanged(
            averageHeartRate: averageHeartRate,
          ),
        );
  }
}
