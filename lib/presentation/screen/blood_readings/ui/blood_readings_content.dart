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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add),
          const SizedBox(width: 8),
          Text(
            Str.of(context).bloodReadingsAddNewResults,
          ),
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
