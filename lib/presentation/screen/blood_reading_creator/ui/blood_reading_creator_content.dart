part of 'blood_reading_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood test creator'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: TextFormField(),
          ),
          const Expanded(
            child: _AllParameters(),
          ),
        ],
      ),
    );
  }
}
