part of 'blood_readings_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            _AddNewReadingButton(),
            SizedBox(height: 16),
            _BloodReadingsList(),
          ],
        ),
      ),
    );
  }
}

class _AddNewReadingButton extends StatelessWidget {
  const _AddNewReadingButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        _onPressed(context);
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add),
          SizedBox(width: 8),
          Text('Dodaj nowe wyniki'),
        ],
      ),
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(
      context: context,
      route: const BloodTestCreatorRoute(),
    );
  }
}
