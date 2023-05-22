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
    return const SizedBox();
  }
}
