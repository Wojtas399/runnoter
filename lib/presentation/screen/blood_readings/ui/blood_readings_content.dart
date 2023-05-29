part of 'blood_readings_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          _AddNewReadingButton(),
          SizedBox(height: 24),
          Expanded(
            child: _BloodReadingsList(),
          ),
        ],
      ),
    );
  }
}

class _AddNewReadingButton extends StatelessWidget {
  const _AddNewReadingButton();

  @override
  Widget build(BuildContext context) {
    return BigButton(
      label: Str.of(context).bloodAddBloodTest,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(
      context: context,
      route: const BloodTestCreatorRoute(),
    );
  }
}
