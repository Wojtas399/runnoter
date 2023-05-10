part of 'health_screen.dart';

class _TodayMorningMeasurement extends StatelessWidget {
  const _TodayMorningMeasurement();

  @override
  Widget build(BuildContext context) {
    return BigButton(
      label: Str.of(context).healthMorningMeasurement,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    await showFullScreenDialog(
      context: context,
      dialog: BlocProvider<HealthBloc>.value(
        value: context.read<HealthBloc>(),
        child: const _MorningMeasurementDialog(),
      ),
    );
  }
}
