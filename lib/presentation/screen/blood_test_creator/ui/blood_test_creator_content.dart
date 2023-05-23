part of 'blood_test_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood test creator'),
      ),
      body: const _Parameters(),
    );
  }
}

class _Parameters extends StatelessWidget {
  const _Parameters();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: BloodTestParameter.values.length,
      padding: const EdgeInsets.all(24),
      itemBuilder: (_, int parameterIndex) {
        return Row(
          children: [
            Text(
              BloodTestParameter.values[parameterIndex].toName(context),
            ),
            const SizedBox(width: 16),
            Text(
              BloodTestParameter.values[parameterIndex].unit.toUIFormat(),
            ),
          ],
        );
      },
    );
  }
}
