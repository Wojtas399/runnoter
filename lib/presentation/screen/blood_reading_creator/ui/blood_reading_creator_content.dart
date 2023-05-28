part of 'blood_reading_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood test creator'),
      ),
      body: GestureDetector(
        onTap: () {
          unfocusInputs();
        },
        child: const Column(
          children: [
            _ReadingDate(),
            Expanded(
              child: _AllParameters(),
            ),
          ],
        ),
      ),
    );
  }
}
