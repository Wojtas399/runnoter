part of 'health_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TodayMeasurementSection(),
            SizedBox(height: 24),
            _ChartsSection(),
            SizedBox(height: 24),
            _ShowAllMeasurementsButton(),
          ],
        ),
      ),
    );
  }
}

class _ShowAllMeasurementsButton extends StatelessWidget {
  const _ShowAllMeasurementsButton();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BigButton(
          label: Str.of(context).healthShowAllMeasurementsButton,
          onPressed: _onPressed,
        ),
      ],
    );
  }

  void _onPressed() {
    navigateTo(const HealthMeasurementsRoute());
  }
}
